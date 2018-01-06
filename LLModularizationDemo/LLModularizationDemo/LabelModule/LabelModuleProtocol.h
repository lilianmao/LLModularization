//
//  LabelModuleProtocol.h
//  LLModularizationDemo
//
//  Created by 李林 on 1/4/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LLModularization/LLModuleProtocol.h>
#import "LabelModuleLabelItemPrt.h"

@protocol LabelModuleProtocol <LLModuleProtocol>

+ (UIViewController *)showLabelModule;

/**
 获取兴趣标签，返回一个协议化对象的数组：NSArray <id<LabelModuleLabelItemPrt>>*
 */
+ (void)getInterestLabelsSuccessed:(LLSuccessBlock)success
                          failured:(LLFailureBlock)failure;

@end
