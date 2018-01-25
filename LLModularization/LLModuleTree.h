//
//  LLModuleTree.h
//  LLModularization
//
//  Created by 李林 on 12/22/17.
//

#import <Foundation/Foundation.h>
#import "LLModuleConst.h"

typedef NS_ENUM(NSInteger, LLModuleTreeNodeType) {
    LLModuleTreeNodeTypeForeground = 0,         // 前端页面节点
    LLModuleTreeNodeTypeBackground = 1          // 后台服务节点
};

/**
 树的节点
 */
@interface LLModuleTreeNode : NSObject

@property (nonatomic, strong) NSArray<LLModuleTreeNode *> *childs;
@property (nonatomic, assign) LLModuleTreeNodeType nodeType;
@property (nonatomic, copy) NSString *moduleName;
@property (nonatomic, copy) NSString *controllerName;
@property (nonatomic, assign) int sequenceNumber;

- (instancetype)initTreeNodeWithNodeType:(LLModuleTreeNodeType)nodeType
                              moduleName:(NSString *)moduleName
                          controllerName:(NSString *)controllerName
                          sequenceNumber:(int)sequenceNumber;

@end

@interface LLModuleTree : NSObject

@property (nonatomic, strong, readonly) LLModuleTreeNode *root;

/**
 向树中添加一个页面节点
 */
+ (void)appendCallerModule:(NSString *)callerModule
          callerController:(NSString *)callerController
              calleeModule:(NSString *)calleeModule
          calleeController:(NSString *)calleeController
                  callType:(LLModuleTreeNodeType)type
              successBlock:(LLBasicSuccessBlock_t)success
              failureBlock:(LLBasicFailureBlock_t)failure;

/**
 popWithPage: pop页面
 */
+ (void)popWithController:(NSArray<NSString *> *)controllers
             successBlock:(LLBasicSuccessBlock_t)success
             failureBlock:(LLBasicFailureBlock_t)failure;

/**
 popToPage: pop到指定页面
 */
+ (void)popToController:(NSString *)controllers
           successBlock:(LLBasicSuccessBlock_t)success
           failureBlock:(LLBasicFailureBlock_t)failure;

@end
