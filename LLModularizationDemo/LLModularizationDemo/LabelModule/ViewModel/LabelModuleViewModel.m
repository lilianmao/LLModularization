//
//  LabelModuleViewModel.m
//  LLModularizationDemo
//
//  Created by 李林 on 1/5/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "LabelModuleViewModel.h"
#import "LabelModuleLabelNode.h"
#import "LabelModuleLabelCategory.h"
#import "LabelModuleLabelManager.h"

@implementation LabelModuleViewModel

#pragma mark - get & set

- (void)getInterestLabelsSuccessed:(LLSuccessBlock)success
                          failured:(LLFailureBlock)failure {
    [[LabelModuleLabelManager sharedLabelManager] getInsterestLabelsSuccessed:success failured:failure];
}

- (void)setInterestLabels:(NSArray<LabelModuleLabelNode *> *)labels
                successed:(LLSuccessBlock)success
                 failured:(LLFailureBlock)failure {
    [[LabelModuleLabelManager sharedLabelManager] setInterestLabels:labels successed:success failured:failure];
}

@end
