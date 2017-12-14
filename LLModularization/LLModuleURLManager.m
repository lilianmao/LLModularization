//
//  LLModuleURLManager.m
//  Pods-LLModularizationDemo
//
//  Created by 李林 on 2017/12/8.
//

#import "LLModuleURLManager.h"
#import "LLModuleUtils.h"
#import "LLModuleProtocolManager.h"
#import "LLModuleURLRoutes.h"

@interface LLModuleURLManager()



@end

@implementation LLModuleURLManager

#pragma mark - sharedManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static LLModuleURLManager *sharedManager = nil;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[LLModuleURLManager alloc] init];
    });
    
    return sharedManager;
}

#pragma mark - register & open

- (BOOL)registerServiceWithServiceName:(NSString *)serviceName
                            URLPattern:(NSString *)urlPattern
                              instance:(NSString *)instanceName {
    if ([LLModuleUtils isNilOrEmtpyForString:urlPattern] || [LLModuleUtils isNilOrEmtpyForString:serviceName]) {
        return NO;
    }
    
    // TODO:建立一个Pattern和Service的映射，模仿MGJRouter和JLRoutes。
    
    return [[LLModuleProtocolManager sharedManager] registerServiceWithServiceName:serviceName instance:instanceName];
}

- (BOOL)callServiceWithURL:(NSString *)url
            navigationMode:(LLModuleNavigationMode)mode
              successBlock:(LLBasicSuccessBlock_t)success
              failureBlock:(LLBasicFailureBlock_t)failure {
    if ([LLModuleUtils isNilOrEmtpyForString:url]) {
        return NO;
    }
    
    // TODO:获取url对应的Service
    NSString *serviceName = @"openLoginModuleWithParams:";  // tmp
    
    return [[LLModuleProtocolManager sharedManager] callServiceWithServiceName:serviceName navigationMode:mode successBlock:success failureBlock:failure];
}

@end
