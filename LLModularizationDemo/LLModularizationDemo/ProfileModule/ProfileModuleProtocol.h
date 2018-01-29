//
//  ProfileModuleProtocol.h
//  LLModularizationDemo
//
//  Created by 李林 on 1/25/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LLModularization/LLModuleProtocol.h>

@protocol ProfileModuleProtocol <LLModuleProtocol>

+ (UIViewController *)showProfileModule;

@end
