//
//  LLModuleTree.m
//  LLModularization
//
//  Created by 李林 on 12/22/17.
//

#import "LLModuleTree.h"
#import "LLModuleUtils.h"
#import "StackForNSObject.h"

#pragma mark - LLModuleTreeNode

@implementation LLModuleTreeNode

- (instancetype)initTreeNodeWithNodeType:(LLModuleTreeNodeType)nodeType
                              moduleName:(NSString *)moduleName
                          controllerName:(NSString *)controllerName
                          sequenceNumber:(int)sequenceNumber {
    if (self = [super init]) {
        _nodeType = nodeType;
        _moduleName = moduleName;
        _controllerName = controllerName;
        _sequenceNumber = sequenceNumber;
        _childs = @[];
    }
    return self;
}

@end

#pragma mark - LLModuleTree

@interface LLModuleTree()

@property (nonatomic, strong) LLModuleTreeNode *root;
@property (nonatomic, assign) int incrementSeqNumber;           // 自增序号，按照时间线
@property (nonatomic, strong) LLModuleTreeNode *findNode;       // 暂存找到的调用节点
@property (nonatomic, strong) StackForNSObject *stack;          // 页面堆栈，用于排查非法Push

// 记录链路的数组
@property (nonatomic, strong) NSMutableArray<LLModuleTreeNode *> *tempChain;
@property (nonatomic, copy) NSArray<LLModuleTreeNode *> *callChain;

@end

@implementation LLModuleTree

#pragma mark - sharedInstance

+ (instancetype)sharedTree {
    static dispatch_once_t onceToken;
    static LLModuleTree *sharedTree = nil;
    
    dispatch_once(&onceToken, ^{
        sharedTree = [[LLModuleTree alloc] init];
    });
    
    return sharedTree;
}

- (StackForNSObject *)stack {
    if (!_stack) {
        _stack = [[StackForNSObject alloc] init];
    }
    return _stack;
}

#pragma mark - append & pop

+ (void)appendCallerModule:(NSString *)callerModule
          callerController:(NSString *)callerController
              calleeModule:(NSString *)calleeModule
          calleeController:(NSString *)calleeController
                  callType:(LLModuleTreeNodeType)type
              successBlock:(LLBasicSuccessBlock_t)success
              failureBlock:(LLBasicFailureBlock_t)failure {
    if ([LLModuleUtils isNilOrEmtpyForString:callerModule]) {
        NSLog(@"Caller is nil.");
        return ;
    }
    if ([LLModuleUtils isNilOrEmtpyForString:calleeModule]) {
        NSLog(@"Callee is nil.");
        return ;
    }
    
    // 初始化
    LLModuleTree *tree = [LLModuleTree sharedTree];
    tree.findNode = nil;
    [tree.tempChain removeAllObjects];
    tree.callChain = @[];
    if (!tree.root) {
        [tree initTreeWithRootStr:callerModule viewControllerName:callerController nodeType:type];
        tree.tempChain = @[].mutableCopy;
    }
    
    switch (type) {
        case LLModuleTreeNodeTypeForeground:
            [tree appendCallerModule:callerModule callerController:callerController calleeModule:calleeModule calleeController:calleeController successBlock:success failureBlock:failure];
            break;
        case LLModuleTreeNodeTypeBackground:
            [tree appendCallerModule:callerModule calleeModule:calleeModule successBlock:success failureBlock:failure];
            break;
        default:
            break;
    }
}

/**
 page节点压入树
 如果find的结果是Service节点，压入两个Page节点
 如果find的结果是Page节点，追加一个Page节点
 */
- (void)appendCallerModule:(NSString *)callerModule
          callerController:(NSString *)callerController
              calleeModule:(NSString *)calleeModule
          calleeController:(NSString *)calleeController
              successBlock:(LLBasicSuccessBlock_t)success
              failureBlock:(LLBasicFailureBlock_t)failure {
    [self findNodeInHighestSequenceNumberWithTreeNode:self.root moduleName:callerModule];
    if (self.findNode) {
        LLModuleTreeNode *fatherNode = self.findNode;
        if (self.findNode.nodeType == LLModuleTreeNodeTypeBackground) {
            fatherNode = [self appendTreeNode:self.findNode nodeName:callerModule nodeController:callerController nodeType:LLModuleTreeNodeTypeForeground];
            [self.stack pushObj:fatherNode];
        }
        LLModuleTreeNode *newNode = [self appendTreeNode:fatherNode nodeName:calleeModule nodeController:calleeController nodeType:LLModuleTreeNodeTypeForeground];
        [self.stack pushObj:newNode];
        
        // 获取到被调用者节点的链路
        [self getCallChainWithRootNode:self.root andGivenNode:newNode];
        if (self.callChain && self.callChain.count > 0) {
            success([self formatTreeNodesChain:self.callChain]);
        } else {
            NSError *err = [[NSError alloc] initWithDomain:NSStringFromClass([self class]) code:-1 userInfo:@{NSLocalizedDescriptionKey:@"Internal Error."}];
            failure(err);
        }
    } else {
        NSError *err = [[NSError alloc] initWithDomain:NSStringFromClass([self class]) code:-1 userInfo:@{NSLocalizedDescriptionKey:@"Internal Error."}];
        failure(err);
    }
}

/**
 service节点压入树
 无论find的结果是Service节点还是Page节点，在下面追加一个Service节点即可
 */
- (void)appendCallerModule:(NSString *)callerModule
              calleeModule:(NSString *)calleeModule
              successBlock:(LLBasicSuccessBlock_t)success
              failureBlock:(LLBasicFailureBlock_t)failure {
    [self findNodeInHighestSequenceNumberWithTreeNode:self.root moduleName:callerModule];
    if (self.findNode) {
        LLModuleTreeNode *fatherNode = self.findNode;
        LLModuleTreeNode *newNode = [self appendTreeNode:fatherNode nodeName:calleeModule nodeController:nil nodeType:LLModuleTreeNodeTypeBackground];
        
        [self getCallChainWithRootNode:self.root andGivenNode:newNode];
        if (self.callChain && self.callChain.count > 0) {
            success([self formatTreeNodesChain:self.callChain]);
        } else {
            NSError *err = [[NSError alloc] initWithDomain:NSStringFromClass([self class]) code:-1 userInfo:@{NSLocalizedDescriptionKey:@"Internal Error."}];
            failure(err);
        }
    } else {
        NSError *err = [[NSError alloc] initWithDomain:NSStringFromClass([self class]) code:-1 userInfo:@{NSLocalizedDescriptionKey:@"Internal Error."}];
        failure(err);
    }
}

/**
 pop页面链路处理
 任何页面都是被之前的页面push/present进来的，首先找到这个页面，然后找打这个页面的链路，push他的页面就在他的上面一级。
 记录的形式：例如 a push b，然后b pop，则记录成 a。
 */
+ (void)popWithController:(NSArray<NSString *> *)controllers
             successBlock:(LLBasicSuccessBlock_t)success
             failureBlock:(LLBasicFailureBlock_t)failure {
    if (controllers.count == 0) {
        NSError *err = [[NSError alloc] initWithDomain:NSStringFromClass([self class]) code:-1 userInfo:@{NSLocalizedDescriptionKey:@"Controllers is nil."}];
        failure(err);
        return ;
    }
    
    LLModuleTree *tree = [LLModuleTree sharedTree];
    [tree.tempChain removeAllObjects];
    tree.callChain = @[];
    // 返回当前栈顶的节点
    LLModuleTreeNode *previousNode = [tree popStackWithControllers:controllers];
    if (previousNode) {
        [tree getCallChainWithRootNode:tree.root andGivenNode:previousNode];
        if (tree.callChain && tree.callChain.count > 0) {
            success([tree formatTreeNodesChain:tree.callChain]);
        }
    } else {
        NSError *err = [[NSError alloc] initWithDomain:NSStringFromClass([self class]) code:-1 userInfo:@{NSLocalizedDescriptionKey:@"Invalid operation."}];
        failure(err);
        return ;
    }
}

+ (void)popToController:(NSString *)controller
           successBlock:(LLBasicSuccessBlock_t)success
           failureBlock:(LLBasicFailureBlock_t)failure {
    if ([LLModuleUtils isNilOrEmtpyForString:controller]) {
        NSError *err = [[NSError alloc] initWithDomain:NSStringFromClass([self class]) code:-1 userInfo:@{NSLocalizedDescriptionKey:@"Controller is nil."}];
        failure(err);
        return ;
    }
    
    LLModuleTree *tree = [LLModuleTree sharedTree];
    [tree.tempChain removeAllObjects];
    tree.callChain = @[];
    // 返回当前栈顶的节点
    LLModuleTreeNode *previousNode = [tree popStackToController:controller];
    if (previousNode) {
        [tree getCallChainWithRootNode:tree.root andGivenNode:previousNode];
        if (tree.callChain && tree.callChain.count > 0) {
            success([tree formatTreeNodesChain:tree.callChain]);
        }
    } else {
        NSError *err = [[NSError alloc] initWithDomain:NSStringFromClass([self class]) code:-1 userInfo:@{NSLocalizedDescriptionKey:@"Invalid operation."}];
        failure(err);
        return ;
    }
}

#pragma mark - Tree Method

- (void)initTreeWithRootStr:(NSString *)rootStr
         viewControllerName:(NSString *)viewControllerName
                   nodeType:(LLModuleTreeNodeType)nodeType{
    if (!_root) {
        self.incrementSeqNumber = 0;        // 根节点序号初始化为0
        _root = [[LLModuleTreeNode alloc] initTreeNodeWithNodeType:nodeType moduleName:rootStr controllerName:viewControllerName sequenceNumber:self.incrementSeqNumber++];
        if (![LLModuleUtils isNilOrEmtpyForString:viewControllerName]) {
            [self.stack pushObj:_root];     // Page节点push入stack
        }
    }
}

/**
 找到最新的名为module的节点
 */
- (void)findNodeInHighestSequenceNumberWithTreeNode:(LLModuleTreeNode *)root
                                         moduleName:(NSString *)moduleName {
    if ([root.moduleName isEqualToString:moduleName] && root.sequenceNumber >= self.findNode.sequenceNumber) {
        // 下次记一下为什么要加controllerName
//        if (![LLModuleUtils isNilOrEmtpyForString:controllerName]) {
//            if ([root.controllerName isEqualToString:controllerName]) {
//                self.findNode = root;
//            }
//        } else {
            self.findNode = root;
//        }
    }
    if (root.childs.count == 0) {
        return ;
    } else {
        [root.childs enumerateObjectsUsingBlock:^(LLModuleTreeNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self findNodeInHighestSequenceNumberWithTreeNode:root.childs[idx] moduleName:moduleName];
        }];
    }
}

/**
 根据节点找出链路
 */
- (void)getCallChainWithRootNode:(LLModuleTreeNode *)root
                    andGivenNode:(LLModuleTreeNode *)givenNode {
    if ([root.moduleName isEqualToString:givenNode.moduleName] && root.sequenceNumber == givenNode.sequenceNumber) {
        [_tempChain addObject:root];
        _callChain = [_tempChain copy];
        return ;
    }
    if (root.childs.count == 0) {
        return ;
    } else {
        [_tempChain addObject:root];
        [root.childs enumerateObjectsUsingBlock:^(LLModuleTreeNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self getCallChainWithRootNode:root.childs[idx] andGivenNode:givenNode];
        }];
        [_tempChain removeLastObject];
    }
}

- (LLModuleTreeNode *)popStackWithControllers:(NSArray<NSString *> *)controllers {
    NSInteger idx = controllers.count-1;
    while (![self.stack isEmpty] && idx >= 0) {
        LLModuleTreeNode *topNode = [self.stack pop];
        if (![topNode.controllerName isEqualToString:controllers[idx--]]) {
            return nil;
        }
    }
    return (LLModuleTreeNode *)[self.stack top];
}

- (LLModuleTreeNode *)popStackToController:(NSString *)controller {
    while (![self.stack isEmpty]) {
        LLModuleTreeNode *topNode = [self.stack top];
        if ([topNode.controllerName isEqualToString:controller]) {
            return topNode;
        }
        [self.stack pop];
    }
    return nil;
}

/**
 在给定的TreeNode上追加一个新的TreeNode
 */
- (LLModuleTreeNode *)appendTreeNode:(LLModuleTreeNode *)treeNode
                            nodeName:(NSString *)moduleName
                      nodeController:(NSString *)moduleController
                            nodeType:(LLModuleTreeNodeType)type {
    if (!treeNode) {
        NSLog(@"TreeNode is nil.");
        return nil;
    }
    if ([LLModuleUtils isNilOrEmtpyForString:moduleName]) {
        NSLog(@"moduleName is nil.");
        return nil;
    }
    
    NSMutableArray *childs = [treeNode.childs mutableCopy];
    LLModuleTreeNode *newNode = [[LLModuleTreeNode alloc] initTreeNodeWithNodeType:type moduleName:moduleName controllerName:moduleController sequenceNumber:self.incrementSeqNumber++];
    [childs addObject:newNode];
    treeNode.childs = [childs copy];
    
    return newNode;
}

- (NSArray<NSString *> *)formatTreeNodesChain:(NSArray<LLModuleTreeNode *> *)nodes {
    NSMutableArray<NSString *> *nodeArray = @[].mutableCopy;
    
    [nodes enumerateObjectsUsingBlock:^(LLModuleTreeNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LLModuleTreeNode *node = (LLModuleTreeNode *)obj;
        NSString *nodeStr = [NSString stringWithFormat:@"%@", node.moduleName];
        if (node.controllerName) {
            nodeStr = [nodeStr stringByAppendingFormat:@".%@", node.controllerName];
        }
        [nodeArray addObject:nodeStr];
    }];
    
    return [nodeArray copy];
}

@end
