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
#import "LLModuleCallStackManager.h"

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
    if ([LLModuleUtils isNilOrEmtpyForString:urlPattern]) {
        NSLog(@"urlPattern is empty.");
        return NO;
    }
    if ([LLModuleUtils isNilOrEmtpyForString:serviceName]) {
        NSLog(@"serviceName is empty.");
        return NO;
    }
    if ([LLModuleUtils isNilOrEmtpyForString:instanceName]) {
        NSLog(@"instanceName is empty.");
        return NO;
    }
    
    return [[LLModuleURLManager sharedManager] registerServiceWithServiceName:serviceName URLPattern:urlPattern instance:instanceName];
}

- (void)callServiceWithCallerConnector:(NSString *)connector
                                   URL:(NSString *)url
                            parameters:(NSDictionary *)params
                        navigationMode:(LLModuleNavigationMode)mode
                          successBlock:(LLBasicSuccessBlock_t)success
                          failureBlock:(LLBasicFailureBlock_t)failure {
    if ([LLModuleUtils isNilOrEmtpyForString:url]) {
        NSError *err = [[NSError alloc] initWithDomain:NSStringFromClass([self class]) code:-1 userInfo:@{NSLocalizedDescriptionKey:@"URL is empty."}];
        failure(err);
        return ;
    }
    if ([LLModuleUtils isNilOrEmtpyForString:connector]) {
        NSError *err = [[NSError alloc] initWithDomain:NSStringFromClass([self class]) code:-1 userInfo:@{NSLocalizedDescriptionKey:@"Connector is empty."}];
        failure(err);
        return ;
    }
    
    [[LLModuleURLManager sharedManager] callServiceWithCallerConnector:connector URL:url parameters:params navigationMode:mode successBlock:success failureBlock:failure];
}

- (void)registerRelyService:(NSString *)serviceName {
    if ([LLModuleUtils isNilOrEmtpyForString:serviceName]) {
        NSLog(@"rely service is empty.");
        return ;
    }
    
    [[LLModuleURLManager sharedManager] registerRelyService:serviceName];
}

- (NSArray *)checkRelyService {
    return [[LLModuleURLManager sharedManager] checkRelyService];
}

- (NSArray *)getModuleCallStack {
    return [LLModuleCallStackManager getModuleCallStack];
}

@end
