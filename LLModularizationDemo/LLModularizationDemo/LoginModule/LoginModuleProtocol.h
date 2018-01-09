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
 URLPattern: ll://login/result?username=value1&password=value2
 function: 初始化LoginModule。

 @param params params为LoginModule_UserName和LoginModule_Password的字典
 @return loginModuleVC
 */
+ (UIViewController *)openLoginModuleWithParams:(NSDictionary *)params;

@end
