//
//  LabelModuleViewModel.h
//  LLModularizationDemo
//
//  Created by 李林 on 1/5/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLMacro.h"

@class LabelModuleLabelNode;

@interface LabelModuleViewModel : NSObject

- (void)getInterestLabelsSuccessed:(LLSuccessBlock)success
                          failured:(LLFailureBlock)failure;

- (void)setInterestLabels:(NSArray<LabelModuleLabelNode *> *)labels
                successed:(LLSuccessBlock)success
                 failured:(LLFailureBlock)failure;

@end
