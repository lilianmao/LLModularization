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
    // TODO: 设计的合理性需要思考
    return [[LLModuleURLManager sharedManager] registerServiceWithServiceName:serviceName URLPattern:urlPattern instance:instanceName];
}

- (BOOL)callServiceWithCallConnector:(id<LLModuleProtocol>)connector
                                 URL:(NSString *)url
                      navigationMode:(LLModuleNavigationMode)mode
                        successBlock:(LLBasicSuccessBlock_t)success
                        failureBlock:(LLBasicFailureBlock_t)failure {
    if ([LLModuleUtils isNilOrEmtpyForString:url] || !connector) {
        return NO;
    }
    
    // TODO: 在这里做链路处理connector
    
    return [[LLModuleURLManager sharedManager] callServiceWithURL:url navigationMode:mode successBlock:success failureBlock:failure];
}

@end
