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

- (BOOL)registerProtocol:(Protocol *)protocol andConnector:(Class)connector {
    if ([LLModuleUtils isNilOrEmtpyForString:NSStringFromProtocol(protocol)] || !connector) {
        return NO;
    }
    return [[LLModuleProtocolManager sharedManager] registerProtocol:protocol andConnector:connector];
}

- (BOOL)openModuleWithCallConnector:(id<LLModuleProtocol>)connector
                           protocol:(Protocol *)protocol
                           selector:(SEL)sel
                             params:(NSDictionary *)params
                     navigationMode:(LLModuleNavigationMode)mode
                    withReturnBlock:(returnBlock)block {
    if ([LLModuleUtils isNilOrEmtpyForString:NSStringFromProtocol(protocol)] || !connector || !sel) {
        return NO;
    }
    
    return [[LLModuleProtocolManager sharedManager] openModuleWithCallConnector:connector protocol:protocol selector:sel params:params navigationMode:mode withReturnBlock:block];
}

- (BOOL)openURL:(NSURL *)URL {
    if ([LLModuleUtils isNilOrEmtpyForString:[URL absoluteString]]) {
        return NO;
    }
    return [[LLModuleURLManager sharedManager] openURL:URL];
}

@end
