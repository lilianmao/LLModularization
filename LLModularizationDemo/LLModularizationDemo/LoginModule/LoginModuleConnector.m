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
    // TODO: URLPattern中关于scheme的定义
    [[LLModule sharedInstance] registerServiceWithServiceName:NSStringFromSelector(@selector(openLoginModuleWithParams:)) URLPattern:@"login" instance:NSStringFromClass(self)];
}


#pragma mark - LLModuleProtocol

- (void)initModule {
    NSLog(@"init Login Module.");
}

- (void)destroyModule {
    NSLog(@"destroy Login Module.");
}

- (void)callServiceWithURL:(NSString *)url
            navigationMode:(LLModuleNavigationMode)mode
              successBlock:(LLBasicSuccessBlock_t)success
              failureBlock:(LLBasicFailureBlock_t)failure {
    
}

#pragma mark - LoginModuleProtocol

+ (UIViewController *)openLoginModuleWithParams:(NSDictionary *)params {
    LoginModuleViewController *loginVC = [[LoginModuleViewController alloc] init];
    
    NSString *username = params[LoginModule_UserName];
    NSString *password = params[LoginModule_Password];
    [loginVC updateWithUserName:username password:password];
    
    return loginVC;
}

@end
