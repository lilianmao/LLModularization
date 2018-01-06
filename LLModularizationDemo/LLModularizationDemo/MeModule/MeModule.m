//
//  MeModule.m
//  LLModularizationDemo
//
//  Created by 李林 on 1/4/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "MeModule.h"
#import "MeModuleMainViewController.h"

@interface MeModule()

@end

@implementation MeModule

#pragma mark - sharedConnector

+ (instancetype)sharedModule {
    static dispatch_once_t onceToken;
    static MeModule *sharedModule = nil;
    
    dispatch_once(&onceToken, ^{
        sharedModule = [[MeModule alloc] init];
    });
    
    return sharedModule;
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

+ (NSArray *)relyService {
    return @[];
}

#pragma mark - MeModuleProtocol

+ (NSString *)getMeModuleAccountWithParams:(NSDictionary *)params {
    MeModuleMainViewController *meAccountVC = [[MeModuleMainViewController alloc] init];
    
    return [meAccountVC getAccountDataWithParams:params];;
}

@end
