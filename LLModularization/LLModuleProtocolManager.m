//
//  LLModuleProtocolManager.m
//  Pods-LLModularizationDemo
//
//  Created by 李林 on 2017/12/8.
//

#import "LLModuleProtocolManager.h"
#import "LLModuleUtils.h"
#import <objc/runtime.h>
#import "LLModuleNavigator.h"
#import "LLModuleCallStackManager.h"

@interface LLModuleProtocolManager()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *serviceInstance_Dict;           // service和Instance的映射
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *viewControllerInstance_dict;    // ViewController和Instance(VC的实现者，模块的发言人)的映射
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

- (NSMutableDictionary<NSString *,NSString *> *)viewControllerInstance_dict {
    if (!_viewControllerInstance_dict) {
        _viewControllerInstance_dict = @{}.mutableCopy;
    }
    return _viewControllerInstance_dict;
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
        NSLog(@"Class doesn't respondTo selector.");
        return NO;
    }
    
    if ([self checkValidService:serviceName]) {
        NSLog(@"Service has been registed.");
        return NO;
    }
    
    if (serviceName.length > 0 && instanceName.length > 0) {
        [self.lock lock];
        [self.serviceInstance_Dict setObject:instanceName forKey:serviceName];
        [self.lock unlock];
    }
    
    return YES;
}

- (void)callServiceWithCallerConnector:(NSString *)connector
                           ServiceName:(NSString *)serviceName
                            parameters:(NSDictionary *)params
                        navigationMode:(LLModuleNavigationMode)mode
                          successBlock:(LLBasicSuccessBlock_t)success
                          failureBlock:(LLBasicFailureBlock_t)failure {
    NSParameterAssert(serviceName != nil);
    
    NSString *instanceName = [self getInstanceWithService:serviceName];
    Class instance = NSClassFromString(instanceName);
    SEL service = NSSelectorFromString(serviceName);
    
    if ([LLModuleUtils isNilOrEmtpyForString:instanceName]) {
        NSString *errMsg = @"Instance is nil.";
        NSError *err = [[NSError alloc] initWithDomain:NSStringFromClass([self class]) code:-1 userInfo:@{NSLocalizedDescriptionKey:errMsg}];
        failure(err);
    }
    if (![instance respondsToSelector:service]) {
        NSString *errMsg = @"Instance doesn't respondTo selector.";
        NSError *err = [[NSError alloc] initWithDomain:NSStringFromClass([self class]) code:-1 userInfo:@{NSLocalizedDescriptionKey:errMsg}];
        failure(err);
    }
    
    id result = [self safePerformAction:service target:instance params:params];
    if (result != nil) {
        if ([result isKindOfClass:[UIViewController class]]) {
            UIViewController *showingVC = (UIViewController *)result;
            NSArray<UIViewController *> *showVCs = [LLModuleNavigator showController:showingVC withNavigationMode:mode];
            // 同时将push和被push的VC和他们对应的module记录下来。
            [self setShowViewControllers:showVCs toInstance:connector];
            [self setShowViewControllers:@[showingVC] toInstance:instanceName];
            
            [LLModuleCallStackManager appendCallStackItemWithCallerConnector:connector calleeConnector:instanceName moduleService:serviceName serviceType:LLModuleTreeServiceTypeForeground];
        } else {
            // 记录链路
            [LLModuleCallStackManager appendCallStackItemWithCallerConnector:connector calleeConnector:instanceName moduleService:serviceName serviceType:LLModuleTreeServiceTypeBackground];
        }
        
        success(result);
    } else {
        NSError *err = [[NSError alloc] initWithDomain:NSStringFromClass([self class]) code:-1 userInfo:@{NSLocalizedDescriptionKey:@"Instance execute selector failured."}];
        failure(err);
    }
}

- (NSString *)getInstanceWithViewController:(NSString *)viewControllerStr {
    NSString *instanceStr = [[self viewControllerInstance_dict] objectForKey:viewControllerStr];
    if (instanceStr.length > 0) {
        return instanceStr;
    }
    return nil;
}

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

- (NSDictionary *)viewControllerDict {
    [self.lock lock];
    NSDictionary *dict = [self.viewControllerInstance_dict copy];
    [self.lock unlock];
    return dict;
}

- (void)setShowViewControllers:(NSArray<UIViewController *> *)viewControllers
                    toInstance:(NSString *)instanceName {
    [self.lock lock];
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.viewControllerInstance_dict setObject:instanceName forKey:NSStringFromClass([obj class])];
    }];
    [self.lock unlock];
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
