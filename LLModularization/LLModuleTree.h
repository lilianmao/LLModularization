//
//  LLModuleTree.h
//  LLModularization
//
//  Created by 李林 on 12/22/17.
//

#import <Foundation/Foundation.h>
#import "LLModuleConst.h"

/**
 树的节点
 */
@interface LLModuleTreeNode : NSObject

@property (nonatomic, strong) NSArray<LLModuleTreeNode *> *childs;
@property (nonatomic, copy) NSString *moduleName;
@property (nonatomic, copy) NSString *controllerName;
@property (nonatomic, assign) int sequenceNumber;

- (instancetype)initTreeNodeWithModuleName:(NSString *)moduleName
                         andControllerName:(NSString *)controllerName
                         andSequenceNumber:(int)sequenceNumber;

@end

@interface LLModuleTree : NSObject

@property (nonatomic, strong, readonly) LLModuleTreeNode *root;

// TODO: 优化tree的算法，Service是否可以和

+ (void)appendCallerModule:(NSString *)callerModule
          callerController:(NSString *)callerController
              calleeModule:(NSString *)calleeModule
          calleeController:(NSString *)calleeController
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
