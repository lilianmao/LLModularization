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

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *serviceInstance_Dict;
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

- (NSMutableDictionary<NSString *, NSString *> *)serviceInstance_Dict {
    if (!_serviceInstance_Dict) {
        _serviceInstance_Dict = @{}.mutableCopy;
    }
    return _serviceInstance_Dict;
}

- (NSRecursiveLock *)lock {
    if (!_lock) {
        _lock = [[NSRecursiveLock alloc] init];
    }
    return _lock;
}

#pragma mark - register & open

- (BOOL)registerServiceWithServiceName:(NSString *)serviceName
                              instance:(NSString *)instanceName {
    NSParameterAssert(serviceName != nil);
    NSParameterAssert(instanceName != nil);
    
    SEL sel = NSSelectorFromString(serviceName);
    Class class = NSClassFromString(instanceName);
    
    if (![class respondsToSelector:sel]) {
        NSLog(@"class doesn't respondTo selector.");
        return NO;
    }
    
    if ([self checkValidService:serviceName]) {
        NSLog(@"protocol has been registed.");
        return NO;
    }
    
    if (serviceName.length > 0 && instanceName.length > 0) {
        [self.lock lock];
        [self.serviceInstance_Dict setObject:instanceName forKey:serviceName];
        [self.lock unlock];
    }
    
    return YES;
}

- (BOOL)callServiceWithServiceName:(NSString *)serviceName
                    navigationMode:(LLModuleNavigationMode)mode
                      successBlock:(LLBasicSuccessBlock_t)success
                      failureBlock:(LLBasicFailureBlock_t)failure {
    
    // TODO: 别忘了执行成功与失败的block。
    
    return YES;
}

 /*
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
        NSLog(@"target doesn't respondTo selector.");
        return NO;
    }
    
    id result = [self safePerformAction:sel target:target params:params];
    if ([result isKindOfClass:[UIViewController class]]) {
        NSLog(@"打开获取的VC");
    } else if (!result){
        block(target, result);
    } else {
        return NO;
    }
    
    return YES;
}
*/

#pragma mark - unregister

#pragma mark - private

- (BOOL)checkValidService:(NSString *)serviceName {
    NSString *instanceStr = [[self serviceDict] objectForKey:serviceName];
    if (instanceStr.length > 0) {
        return YES;
    }
    return NO;
}

- (NSString *)getInstanceWithService:(NSString *)serviceName {
    NSString *instanceStr = [[self serviceDict] objectForKey:serviceName];
    return instanceStr;
}

- (NSDictionary *)serviceDict {
    [self.lock lock];
    NSDictionary *dict = [self.serviceInstance_Dict copy];
    [self.lock unlock];
    return dict;
}

- (id)safePerformAction:(SEL)action target:(Class)target params:(NSDictionary *)params {
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
