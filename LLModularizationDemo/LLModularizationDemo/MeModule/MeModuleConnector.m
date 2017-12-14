//
//  MeModuleConnector.m
//  LLModularizationDemo
//
//  Created by 李林 on 2017/12/9.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "MeModuleConnector.h"
#import "LLUtils.h"

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
    
}

#pragma mark - LLModuleProtocol

- (void)initModule {
    NSLog(@"init Me Module.");
}

- (void)destroyModule {
    NSLog(@"destroy Me Module.");
}

- (void)callServiceWithURL:(NSString *)url
            navigationMode:(LLModuleNavigationMode)mode
              successBlock:(LLBasicSuccessBlock_t)success
              failureBlock:(LLBasicFailureBlock_t)failure {
    // 做一下判空
    if ([LLUtils isNilOrEmtpyForString:url]) {
        failure(nil);
    }
    
    [[LLModule sharedInstance] callServiceWithCallConnector:self URL:url navigationMode:mode successBlock:success failureBlock:failure];
}

#pragma mark - MeModuleProtocol



@end
