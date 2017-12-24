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
                         andSequenceNumber:(int)sequenceNumber {
    if (self = [super init]) {
        _moduleName = moduleName;
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

#pragma mark - Tree Method

- (void)initTreeWithRootStr:(NSString *)rootStr {
    if (!_root) {
        self.incrementSeqNumber = 0;    // 根节点序号初始化为0
        _root = [[LLModuleTreeNode alloc] initTreeNodeWithModuleName:rootStr andSequenceNumber:self.incrementSeqNumber++];
        [self.stack pushObj:_root];     // 存在争议
    }
}

/**
 找到最新的与该节点同名的节点
 */
- (void)findNodeInHighestSequenceNumberWithTreeNode:(LLModuleTreeNode *)root
                                      andModuleName:(NSString *)moduleName {
    if ([root.moduleName isEqualToString:moduleName] && root.sequenceNumber >= self.findNode.sequenceNumber) {
        self.findNode = root;
    }
    if (root.childs.count == 0) {
        return ;
    } else {
        [root.childs enumerateObjectsUsingBlock:^(LLModuleTreeNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self findNodeInHighestSequenceNumberWithTreeNode:root.childs[idx] andModuleName:moduleName];
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

- (LLModuleTreeNode *)getPopPageFromStackWithPage:(NSString *)page {
    LLModuleTreeNode *topTreeNode = (LLModuleTreeNode *)[self.stack top];
    if ([topTreeNode.moduleName isEqualToString:page]) {
        [self.stack pop];
        return (LLModuleTreeNode *)[self.stack top];
    }
    return nil;
}

#pragma mark - append & pop

+ (NSArray *)appendCaller:(NSString *)callerStr
                andCallee:(NSString *)calleeStr {
    if ([LLModuleUtils isNilOrEmtpyForString:callerStr] || [LLModuleUtils isNilOrEmtpyForString:calleeStr]) {
        NSLog(@"Caller or Callee is nil.");
        return nil;
    }
    
    // 初始化
    LLModuleTree *tree = [LLModuleTree sharedTree];
    tree.findNode = nil;
    [tree.tempChain removeAllObjects];
    tree.callChain = @[];
    if (!tree.root) {
        [tree initTreeWithRootStr:callerStr];
        tree.tempChain = @[].mutableCopy;
    }
    
    [tree findNodeInHighestSequenceNumberWithTreeNode:tree.root andModuleName:callerStr];
    if (tree.findNode) {
        // 初始化一个被调用者节点，加载调用者的childs数组中。
        LLModuleTreeNode *newNode = [[LLModuleTreeNode alloc] initTreeNodeWithModuleName:calleeStr andSequenceNumber:tree.incrementSeqNumber++];
        NSMutableArray *childNodes = [tree.findNode.childs mutableCopy];
        [childNodes addObject:newNode];
        tree.findNode.childs = [childNodes copy];
        [tree.stack pushObj:newNode];
        
        // 获取到被调用者节点的链路
        [tree getCallChainWithRootNode:tree.root andGivenNode:newNode];
        if (tree.callChain) {
            NSMutableArray *returnChain = @[].mutableCopy;
            [tree.callChain enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                LLModuleTreeNode *node = (LLModuleTreeNode *)obj;
                [returnChain addObject:node.moduleName];
            }];
            return [returnChain copy];
        } else {
            NSLog(@"Internal Error.");
        }
    } else {
        NSLog(@"Internal Error.");
    }
    
    return nil;
}

/**
 pop页面链路处理
 任何页面都是被之前的页面push/present进来的，首先找到这个页面，然后找打这个页面的链路，push他的页面就在他的上面一级。
 记录的形式：例如 a push b，然后b pop，则记录成 a->b->a，pop本质上也是一种推进。
 */
+ (NSArray *)popPage:(NSString *)page {
    if ([LLModuleUtils isNilOrEmtpyForString:page]) {
        NSLog(@"Page is nil.");
        return nil;
    }
    
    LLModuleTree *tree = [LLModuleTree sharedTree];
    LLModuleTreeNode *previousNode = [tree getPopPageFromStackWithPage:page];
    if (!previousNode) {
        NSLog(@"Invalid operation.");
        return nil;
    }
    
    return [self appendCaller:page andCallee:previousNode.moduleName];
}

@end
