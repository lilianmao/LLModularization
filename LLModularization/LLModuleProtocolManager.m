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

#pragma mark - sharedManager

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

#pragma mark - register & open

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

- (BOOL)openModuleWithCallConnector:(id<LLModuleProtocol>)connector
                           protocol:(Protocol *)protocol
                           selector:(SEL)sel
                             params:(NSDictionary *)params
                     navigationMode:(LLModuleNavigationMode)mode
                    withReturnBlock:(returnBlock)block {
    NSParameterAssert(NSStringFromProtocol(protocol) != nil);
    NSParameterAssert(connector != nil);
    
    // 1. 做缓存 2. 做链路
    
    NSString *targetStr = [self getConnectorWithProtocol:protocol];
    if ([LLModuleUtils isNilOrEmtpyForString:targetStr]) {
        return NO;
    }
    Class target = NSClassFromString(targetStr);
    if (![target respondsToSelector:sel]) {
        return NO;
    }
    
    id result = [self safePerformAction:sel target:target params:params];
    if ([result isKindOfClass:[UIViewController class]]) {
#warning 3. 获取当前的VC，根据mode显示新的VC。
        NSLog(@"打开获取的VC");
    } else if (!result){
        block(target, result);
    } else {
        return NO;
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

- (NSString *)getConnectorWithProtocol:(Protocol *)protocol {
    NSString *connectorStr = [[self protocolDict] objectForKey:NSStringFromProtocol(protocol)];
    return connectorStr;
}

- (NSDictionary *)protocolDict {
    [self.lock lock];
    NSDictionary *dict = [self.protocolConnector_Dict copy];
    [self.lock unlock];
    return dict;
}

- (id)safePerformAction:(SEL)action target:(Class)target params:(NSDictionary *)params
{
    NSMethodSignature* methodSig = [target methodSignatureForSelector:action];
    if(methodSig == nil) {
        return nil;
    }
    const char* retType = [methodSig methodReturnType];
    
    if (strcmp(retType, @encode(void)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        return nil;
    }
    
    if (strcmp(retType, @encode(NSInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(BOOL)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(CGFloat)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(NSUInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
}

@end
