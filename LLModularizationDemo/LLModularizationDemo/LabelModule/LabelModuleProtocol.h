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

/*
 这个Module所需要的参数
 */
static NSString *const LabelModule_SuccessBlock = @"label_successBlock";
static NSString *const LabelModule_FailureBlock = @"label_failureBlock";

@protocol LabelModuleProtocol <LLModuleProtocol>

+ (UIViewController *)showLabelModule;

/**
 URLPattern: ll://label.get
 function: 获取兴趣标签，返回一个协议化对象的数组：NSArray <id<LabelModuleLabelItemPrt>>*
 
 @param params params为LabelModule_Success和LabelModule_FailureBlock的字典
 */
+ (void)getInterestLabelsWithParams:(NSDictionary *)params;

@end
