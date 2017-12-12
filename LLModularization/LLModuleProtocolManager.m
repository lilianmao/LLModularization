//
//  LLModuleProtocolManager.m
//  Pods-LLModularizationDemo
//
//  Created by 李林 on 2017/12/8.
//

#import "LLModuleProtocolManager.h"
#import "LLModuleUtils.h"
#import <objc/runtime.h>

@interface LLModuleProtocolManager()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *protocolConnector_Dict;
@property (nonatomic, strong) NSRecursiveLock *lock;

@end

@implementation LLModuleProtocolManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static LLModuleProtocolManager *sharedManager = nil;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[LLModuleProtocolManager alloc] init];
    });
    
    return sharedManager;
}

#pragma mark - Lazy Load

- (NSMutableDictionary<NSString *, NSString *> *)protocolConnector_Dict {
    if (!_protocolConnector_Dict) {
        _protocolConnector_Dict = @{}.mutableCopy;
    }
    return _protocolConnector_Dict;
}

- (NSRecursiveLock *)lock {
    if (!_lock) {
        _lock = [[NSRecursiveLock alloc] init];
    }
    return _lock;
}

#pragma mark - register

- (BOOL)registerProtocol:(Protocol *)protocol andConnector:(Class)connector {
    NSParameterAssert(NSStringFromProtocol(protocol) != nil);
    NSParameterAssert(connector != nil);
    
    if (![connector conformsToProtocol:protocol]) {
        NSLog(@"connector don't conforms to protocol.");
        return NO;
    }
    
    if ([self checkValidProtocol:protocol]) {
        NSLog(@"protocol has been registed.");
        return NO;
    }
    
    NSString *key = NSStringFromProtocol(protocol);
    NSString *value = NSStringFromClass(connector);
    
    if (key.length > 0 && value.length > 0) {
        [self.lock lock];
        [self.protocolConnector_Dict setObject:value forKey:key];
        [self.lock unlock];
    }
    
    return YES;
}

#pragma mark - unregister

#pragma mark - private

- (BOOL)checkValidProtocol:(Protocol *)protocol {
    NSString *connectorStr = [[self protocolDict] objectForKey:NSStringFromProtocol(protocol)];
    if (connectorStr.length > 0) {
        return YES;
    }
    return NO;
}

- (NSDictionary *)protocolDict {
    [self.lock lock];
    NSDictionary *dict = [self.protocolConnector_Dict copy];
    [self.lock unlock];
    return dict;
}

@end
