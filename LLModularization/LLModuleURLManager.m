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

@property (nonatomic, copy) NSArray *urlPatterns;

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

- (NSArray *)urlPatterns {
    if (!_urlPatterns) {
        _urlPatterns = @[];
    }
    return _urlPatterns;
}

#pragma mark - register & open

- (BOOL)registerServiceWithServiceName:(NSString *)serviceName
                            URLPattern:(NSString *)urlPattern
                              instance:(NSString *)instanceName {
    if ([LLModuleUtils isNilOrEmtpyForString:urlPattern] || [LLModuleUtils isNilOrEmtpyForString:serviceName]) {
        return NO;
    }
    
    NSMutableArray *urls = [self.urlPatterns mutableCopy];
    [urls addObject:urlPattern];
    self.urlPatterns = urls;
    
    [LLModuleURLRoutes registerURLPattern:urlPattern toService:serviceName];
    
    return [[LLModuleProtocolManager sharedManager] registerServiceWithServiceName:serviceName instance:instanceName];
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
    
    NSDictionary *openResult = [LLModuleURLRoutes openURL:url withUserInfo:params];
    if (openResult[LLRoutesStatus]) {
        [[LLModuleProtocolManager sharedManager] callServiceWithCallerConnector:connector ServiceName:openResult[LLRoutesService] parameters:openResult[LLRoutesParameters] navigationMode:mode successBlock:success failureBlock:failure];
    } else {
        NSError *err = [[NSError alloc] initWithDomain:NSStringFromClass([self class]) code:-1 userInfo:@{NSLocalizedDescriptionKey:@"URL open service failured."}];
        failure(err);
    }
}

- (BOOL)checkIfRegisterURLPattern:(NSString *)urlPattern {
    if ([_urlPatterns indexOfObject:urlPattern]) {
        return YES;
    }
    return NO;
}

@end
