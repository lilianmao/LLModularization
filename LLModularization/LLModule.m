//
//  LLModule.m
//  Pods-LLModularizationDemo
//
//  Created by 李林 on 2017/12/8.
//

#import "LLModule.h"
#import "LLModuleProtocolManager.h"
#import "LLModuleURLManager.h"
#import "LLModuleUtils.h"

@interface LLModule()

@end

@implementation LLModule

#pragma mark - sharedInstance

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LLModule *sharedInstance = nil;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LLModule alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - register & open

- (BOOL)registerServiceWithServiceName:(NSString *)serviceName
                            URLPattern:(NSString *)urlPattern
                              instance:(NSString *)instanceName {
    if ([LLModuleUtils isNilOrEmtpyForString:urlPattern] || [LLModuleUtils isNilOrEmtpyForString:serviceName] || [LLModuleUtils isNilOrEmtpyForString:instanceName]) {
        return NO;
    }
    
    return [[LLModuleURLManager sharedManager] registerServiceWithServiceName:serviceName URLPattern:urlPattern instance:instanceName];
}

- (void)callServiceWithCallConnector:(NSString *)connector
                                 URL:(NSString *)url
                          parameters:(NSDictionary *)params
                      navigationMode:(LLModuleNavigationMode)mode
                        successBlock:(LLBasicSuccessBlock_t)success
                        failureBlock:(LLBasicFailureBlock_t)failure {
    if ([LLModuleUtils isNilOrEmtpyForString:url] || !connector) {
        NSError *err = [[NSError alloc] initWithDomain:NSStringFromClass([self class]) code:-1 userInfo:@{NSLocalizedDescriptionKey:@"URL or Connector is empty."}];
        failure(err);
    }
    
    [[LLModuleURLManager sharedManager] callServiceWithCallConnector:connector URL:url parameters:params navigationMode:mode successBlock:success failureBlock:failure];
}

@end
