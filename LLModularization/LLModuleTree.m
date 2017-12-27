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

- (instancetype)initTreeNodeWithModuleName:(NSString *)moduleName
                         andControllerName:(NSString *)controllerName
                         andSequenceNumber:(int)sequenceNumber {
    if (self = [super init]) {
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
        [tree initTreeWithRootStr:callerModule andViewControllerName:callerController];
        tree.tempChain = @[].mutableCopy;
    }
    
    [tree findNodeInHighestSequenceNumberWithTreeNode:tree.root moduleName:callerModule controllerName:callerController];
    if (tree.findNode) {
        // 初始化一个被调用者节点，加载调用者的childs数组中。
        LLModuleTreeNode *newNode = [[LLModuleTreeNode alloc] initTreeNodeWithModuleName:calleeModule andControllerName:calleeController andSequenceNumber:tree.incrementSeqNumber++];
        NSMutableArray *childNodes = [tree.findNode.childs mutableCopy];
        [childNodes addObject:newNode];
        tree.findNode.childs = [childNodes copy];
        [tree.stack pushObj:newNode];
        
        // 获取到被调用者节点的链路
        [tree getCallChainWithRootNode:tree.root andGivenNode:newNode];
        if (tree.callChain && tree.callChain.count > 0) {
            success([tree formatTreeNodesChain:tree.callChain]);
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
    LLModuleTreeNode *previousNode = [tree popStackWithControllers:controllers];
    if (previousNode) {
        NSArray<LLModuleTreeNode *> *callChain = [tree.stack getAllObjects];
        if (callChain.count > 0) {
            success([tree formatTreeNodesChain:callChain]);
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
    LLModuleTreeNode *previousNode = [tree popStackToController:controller];
    if (previousNode) {
        NSArray<LLModuleTreeNode *> *callChain = [tree.stack getAllObjects];
        if (callChain.count > 0) {
            success([tree formatTreeNodesChain:callChain]);
        }
    } else {
        NSError *err = [[NSError alloc] initWithDomain:NSStringFromClass([self class]) code:-1 userInfo:@{NSLocalizedDescriptionKey:@"Invalid operation."}];
        failure(err);
        return ;
    }
}

#pragma mark - Tree Method

- (void)initTreeWithRootStr:(NSString *)rootStr
      andViewControllerName:(NSString *)viewControllerName{
    if (!_root) {
        self.incrementSeqNumber = 0;    // 根节点序号初始化为0
        _root = [[LLModuleTreeNode alloc] initTreeNodeWithModuleName:rootStr andControllerName:viewControllerName andSequenceNumber:self.incrementSeqNumber++];
        [self.stack pushObj:_root];     // 存在争议
    }
}

/**
 找到最新的与该节点同名的节点
 */
- (void)findNodeInHighestSequenceNumberWithTreeNode:(LLModuleTreeNode *)root
                                         moduleName:(NSString *)moduleName
                                     controllerName:(NSString *)controllerName{
    if ([root.moduleName isEqualToString:moduleName]&& root.sequenceNumber >= self.findNode.sequenceNumber) {
        if (controllerName && ![root.controllerName isEqualToString:controllerName]) {
            return ;
        }
        self.findNode = root;
    }
    if (root.childs.count == 0) {
        return ;
    } else {
        [root.childs enumerateObjectsUsingBlock:^(LLModuleTreeNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self findNodeInHighestSequenceNumberWithTreeNode:root.childs[idx] moduleName:moduleName controllerName:controllerName];
        }];
    }
}

/**
 根据节点找出链路
 */
- (void)getCallChainWithRootNode:(LLModuleTreeNode *)root
                    andGivenNode:(LLModuleTreeNode *)givenNode {
    if ([root.controllerName isEqualToString:givenNode.controllerName] && root.sequenceNumber == givenNode.sequenceNumber) {
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
