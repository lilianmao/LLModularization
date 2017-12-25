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
@property (nonatomic, assign) int sequenceNumber;

- (instancetype)initTreeNodeWithModuleName:(NSString *)moduleName
                         andSequenceNumber:(int)sequenceNumber;

@end

@interface LLModuleTree : NSObject

@property (nonatomic, strong, readonly) LLModuleTreeNode *root;

+ (void)appendCaller:(NSString *)callerStr
           andCallee:(NSString *)calleeStr
        successBlock:(LLBasicSuccessBlock_t)success
        failureBlock:(LLBasicFailureBlock_t)failure;

/**
 popToPage: pop到指定页面
 */
+ (void)popToPage:(NSString *)page
     successBlock:(LLBasicSuccessBlock_t)success
     failureBlock:(LLBasicFailureBlock_t)failure;

/**
 popWithPage: 指定页面无法获取，传入最近的module，向上一级寻找page
 */
+ (void)popWithPage:(NSString *)page
       successBlock:(LLBasicSuccessBlock_t)success
       failureBlock:(LLBasicFailureBlock_t)failure;

#warning 1. 写一个全面的demo(包括非法pop一次或者多次)

@end
