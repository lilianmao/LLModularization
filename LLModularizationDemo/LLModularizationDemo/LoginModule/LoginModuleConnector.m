//
//  LoginModuleConnector.m
//  LLModularizationDemo
//
//  Created by 李林 on 2017/12/8.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "LoginModuleConnector.h"
#import "LoginModuleViewController.h"

@interface LoginModuleConnector()

@end

@implementation LoginModuleConnector

#pragma mark - sharedConnector

+ (instancetype)sharedConnector {
    static dispatch_once_t onceToken;
    static LoginModuleConnector *sharedConnector = nil;
    
    dispatch_once(&onceToken, ^{
        sharedConnector = [[LoginModuleConnector alloc] init];
    });
    
    return sharedConnector;
}

#pragma mark - register

+ (void)load {
    [[LLModule sharedInstance] registerProtocol:@protocol(LoginModuleProtocol) andConnector:[LoginModuleConnector class]];
}


#pragma mark - LLModuleProtocol

- (void)initModule {
    NSLog(@"init Login Module.");
}

- (void)destroyModule {
    NSLog(@"destroy Login Module.");
}

- (BOOL)openModuleWithProtocol:(Protocol *)protocol
                      selector:(SEL)sel
                        params:(NSDictionary *)params
                navigationMode:(LLModuleNavigationMode)mode
               withReturnBlock:(returnBlock)block {
    return YES;
}

#pragma mark - LoginModuleProtocol

+ (UIViewController *)createLoginModuleWithParams:(NSDictionary *)params {
    LoginModuleViewController *loginVC = [[LoginModuleViewController alloc] init];
    [loginVC updateWithUserName:params[LoginModule_UserName] password:params[LoginModule_Password]];
    return loginVC;
}

@end
