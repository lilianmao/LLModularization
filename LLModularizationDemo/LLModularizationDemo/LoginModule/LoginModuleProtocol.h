//
//  LoginModuleProtocol.h
//  LLModularizationDemo
//
//  Created by 李林 on 12/12/17.
//  Copyright © 2017 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LLModularization/LLModuleProtocol.h>

/*
 这个Module所需要的参数
 */
static NSString *const LoginModule_UserName = @"username";
static NSString *const LoginModule_Password = @"password";

@protocol LoginModuleProtocol <LLModuleProtocol>

@required

/**
 初始化

 @param params params为LoginModule_UserName和LoginModule_Password的字典
 @return loginModuleVC
 */
+ (UIViewController *)createLoginModuleWithParams:(NSDictionary *)params;

@end
