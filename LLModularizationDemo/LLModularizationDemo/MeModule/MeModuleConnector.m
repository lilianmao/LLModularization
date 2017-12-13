//
//  MeModuleConnector.m
//  LLModularizationDemo
//
//  Created by 李林 on 2017/12/9.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "MeModuleConnector.h"

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
    [[LLModule sharedInstance] registerProtocol:@protocol(MeModuleProtocol) andConnector:[MeModuleConnector class]];
}

#pragma mark - open

- (BOOL)openModuleWithProtocol:(Protocol *)protocol
                      selector:(SEL)sel
                        params:(NSDictionary *)params
                navigationMode:(LLModuleNavigationMode)mode
               withReturnBlock:(returnBlock)block {
    if (!protocol || !sel) {
        return NO;
    }
    
    return [[LLModule sharedInstance] openModuleWithCallConnector:self protocol:protocol selector:sel params:params navigationMode:mode withReturnBlock:block];
}

#pragma mark - LLModuleProtocol

- (void)initModule {
    NSLog(@"init Me Module.");
}

- (void)destroyModule {
    NSLog(@"destroy Me Module.");
}

#pragma mark - MeModuleProtocol

- (instancetype)initMeModuleWithName:(NSString *)name
                              andAge:(NSInteger)age {
    return nil;
}

@end
