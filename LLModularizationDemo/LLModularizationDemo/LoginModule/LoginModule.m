//
//  LoginModule.m
//  LLModularizationDemo
//
//  Created by 李林 on 1/4/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "LoginModule.h"
#import "LoginModuleMainViewController.h"

#import <LLModularization/LLModule.h>

@interface LoginModule()

@end

@implementation LoginModule

#pragma mark - sharedConnector

+ (instancetype)sharedModule {
    static dispatch_once_t onceToken;
    static LoginModule *sharedModule = nil;
    
    dispatch_once(&onceToken, ^{
        sharedModule = [[LoginModule alloc] init];
    });
    
    return sharedModule;
}

#pragma mark - register

+ (void)load {
    [[LLModule sharedInstance] registerServiceWithServiceName:NSStringFromSelector(@selector(openLoginModuleWithParams:)) URLPattern:@"ll://login/:query.html" instance:NSStringFromClass(self)];
    [[LLModule sharedInstance] registerRelyService:nil];
}


#pragma mark - LLModuleProtocol

- (void)initModule {
    NSLog(@"init Login Module.");
}

- (void)destroyModule {
    NSLog(@"destroy Login Module.");
}

- (void)callServiceWithURL:(NSString *)url
                parameters:(NSDictionary *)params
            navigationMode:(LLModuleNavigationMode)mode
              successBlock:(LLBasicSuccessBlock_t)success
              failureBlock:(LLBasicFailureBlock_t)failure {
    
}

#pragma mark - LoginModuleProtocol

+ (UIViewController *)openLoginModuleWithParams:(NSDictionary *)params {
    NSString *username = params[LoginModule_UserName];
    NSString *password = params[LoginModule_Password];
    NSLog(@"params : %@", params);
    
    LoginModuleMainViewController *loginVC = [[LoginModuleMainViewController alloc] initWithUserName:username password:password];
    
    return loginVC;
}

@end
