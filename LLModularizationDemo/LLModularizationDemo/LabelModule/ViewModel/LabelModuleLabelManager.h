//
//  LabelModuleLabelManager.h
//  LLModularizationDemo
//
//  Created by 李林 on 1/5/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLMacro.h"

@class LabelModuleLabelNode;

@interface LabelModuleLabelManager : NSObject

+ (instancetype) sharedLabelManager;

/**
 兴趣标签get方法
 
 @param success success的block中返回数据
 */
- (void)getInsterestLabelsSuccessed:(LLSuccessBlock)success
                           failured:(LLFailureBlock)failure;

/**
 兴趣标签set方法
 
 @param labels 需要设置的兴趣标签
 */
- (void)setInterestLabels:(NSArray<LabelModuleLabelNode *> *)labels
                successed:(LLSuccessBlock)success
                 failured:(LLFailureBlock)failure;

@end
