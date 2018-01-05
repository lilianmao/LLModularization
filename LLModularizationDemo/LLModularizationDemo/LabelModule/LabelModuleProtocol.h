//
//  LabelModuleProtocol.h
//  LLModularizationDemo
//
//  Created by 李林 on 1/4/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LLModularization/LLModuleProtocol.h>

@protocol LabelModuleProtocol <LLModuleProtocol>

+ (UIViewController *)showLabelModule;

// TODO: 协议化对象
+ (NSArray *)getInterestLabels;

@end
