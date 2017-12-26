//
//  MeModuleConnector.m
//  LLModularizationDemo
//
//  Created by 李林 on 2017/12/9.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "MeModuleConnector.h"
#import "LLUtils.h"
#import "MeModuleMainViewController.h"

@interface MeModuleConnector()

@end

@implementation MeModuleConnector

#pragma mark - sharedConnector

+ (instancetype)sharedConnector {
    static dispatch_once_t onceToken;
    static MeModuleConnector *sharedConnector = nil;
    
    dispatch_once(&onceToken, ^{
        sharedConnector = [[MeModuleConnector alloc] init];
    });
    
    return sharedConnector;
}

#pragma mark - register

+ (void)load {
    [[LLModule sharedInstance] registerServiceWithServiceName:NSStringFromSelector(@selector(getMeModuleAccountWithParams:)) URLPattern:@"ll://getAccount" instance:NSStringFromClass(self)];
}

#pragma mark - LLModuleProtocol

- (void)initModule {
    NSLog(@"init Me Module.");
}

- (void)destroyModule {
    NSLog(@"destroy Me Module.");
}

- (void)callServiceWithURL:(NSString *)url
                parameters:(NSDictionary *)params
            navigationMode:(LLModuleNavigationMode)mode
              successBlock:(LLBasicSuccessBlock_t)success
              failureBlock:(LLBasicFailureBlock_t)failure {
    if ([LLUtils isNilOrEmtpyForString:url]) {
        failure(nil);
    }
    
    [[LLModule sharedInstance] callServiceWithCallerConnector:NSStringFromClass([self class]) URL:url parameters:params navigationMode:mode successBlock:success failureBlock:failure];
}

#pragma mark - MeModuleProtocol

+ (NSString *)getMeModuleAccountWithParams:(NSDictionary *)params {
    MeModuleMainViewController *meAccountVC = [[MeModuleMainViewController alloc] init];
    
    return nil;
}

@end
