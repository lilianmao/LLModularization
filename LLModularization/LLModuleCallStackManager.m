//
//  LLModuleCallStackManager.m
//  LLModularization
//
//  Created by 李林 on 12/19/17.
//

#import "LLModuleCallStackManager.h"
#import "LLModuleUtils.h"
#import "StackForNSObject.h"
#import "LLModuleTree.h"

#pragma mark - LLModuleTreeCallStack

@implementation LLModuleCallStackItem

- (instancetype)initWithModuleCallChain:(NSArray *)callChain
                             andService:(NSString *)service
                         andServiceType:(LLModuleServiceType)serviceType {
    if (self = [super init]) {
        _moduleCallChain = callChain;
        _service = service;
        _serviceType = serviceType;
    }
    return self;
}

- (NSString *)description {
    NSString *callChainStr = [_moduleCallChain componentsJoinedByString:@"->"];
    return [NSString stringWithFormat:@"<callChain = %@, service = %@, serviceType = %@>", callChainStr, _service, [self formatToString:_serviceType]];
}

- (NSString *)formatToString:(LLModuleServiceType)type {
    NSString *result = nil;
    
    switch (type) {
        case LLModuleServiceTypePush:
            result = @"Push";
            break;
        case LLModuleServiceTypePresent:
            result = @"Present";
            break;
        case LLModuleServiceTypePop:
            result = @"Pop";
            break;
        case LLModuleServiceTypeDismiss:
            result = @"Dismiss";
            break;
        case LLModuleServiceTypeBackground:
            result = @"Background";
            break;
        default:
            result = @"None";
            break;
    }
    
    return result;
}

@end

@interface LLModuleCallStackManager()

@property (nonatomic, strong) StackForNSObject *stack;

@end

@implementation LLModuleCallStackManager

#pragma mark - sharedManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static LLModuleCallStackManager *sharedManager = nil;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[LLModuleCallStackManager alloc] init];
    });
    
    return sharedManager;
}

#pragma mark - Lazy Load

- (StackForNSObject *)stack {
    if (!_stack) {
        _stack = [[StackForNSObject alloc] init];
    }
    return _stack;
}

#pragma mark - get & append

+ (NSArray *)getModuleCallStack {
    return [[LLModuleCallStackManager sharedManager] getModuleCallStack];
}

+ (void)appendCallStackItemWithCallerModule:(NSString *)callerModule
                           callerController:(NSString *)callerController
                               calleeModule:(NSString *)calleeModule
                           calleeController:(NSString *)calleeController
                              moduleService:(NSString *)service
                                serviceType:(LLModuleServiceType)type {
    [[LLModuleCallStackManager sharedManager] appendCallStackItemWithCallerModule:callerModule callerController:callerController calleeModule:calleeModule calleeController:calleeController moduleService:service serviceType:type];
}

+ (void)popWithControllers:(NSArray<NSString *> *)controllers
               serviceName:(NSString *)serviceName
                   popType:(LLModuleServiceType)type {
    [[LLModuleCallStackManager sharedManager] popWithControllers:controllers serviceName:serviceName popType:type];
}

+ (void)popToController:(NSString *)controller
            serviceName:(NSString *)serviceName
                popType:(LLModuleServiceType)type {
    [[LLModuleCallStackManager sharedManager] popToController:controller serviceName:serviceName popType:type];
}

#pragma mark - Private Method

- (NSArray *)getModuleCallStack {
    return [self.stack getAllObjects];
}

- (void)appendCallStackItemWithCallerModule:(NSString *)callerModule
                           callerController:(NSString *)callerController
                               calleeModule:(NSString *)calleeModule
                           calleeController:(NSString *)calleeController
                              moduleService:(NSString *)service
                                serviceType:(LLModuleServiceType)type {
    if ([LLModuleUtils isNilOrEmtpyForString:callerModule]) {
        NSLog(@"Append Failured. Caller is nil.");
        return ;
    }
    if ([LLModuleUtils isNilOrEmtpyForString:calleeModule]) {
        NSLog(@"Append Failured. Callee is nil.");
        return ;
    }
    if ([LLModuleUtils isNilOrEmtpyForString:service]) {
        NSLog(@"Append Failured. Service is nil.");
        return ;
    }
    
    __block LLModuleCallStackItem *stackItem = nil;
    LLModuleTreeNodeType nodeType = (type==LLModuleServiceTypeBackground) ? LLModuleTreeNodeTypeBackground : LLModuleTreeNodeTypeForeground;
    [LLModuleTree appendCallerModule:callerModule callerController:callerController calleeModule:calleeModule calleeController:calleeController callType:nodeType successBlock:^(id result) {
        NSArray *callChainArray = result;
        stackItem = [[LLModuleCallStackItem alloc] initWithModuleCallChain:callChainArray andService:service andServiceType:type];
    } failureBlock:^(NSError *err) {
        stackItem = [[LLModuleCallStackItem alloc] initWithModuleCallChain:nil andService:err.localizedDescription andServiceType:LLModuleServiceTypeNone];
    }];
    
    NSLog(@"%@", stackItem);
    [self.stack pushObj:stackItem];
}

- (void)popWithControllers:(NSArray<NSString *> *)controllers
               serviceName:(NSString *)serviceName
                   popType:(LLModuleServiceType)type {
    __block LLModuleCallStackItem *stackItem = nil;
    [LLModuleTree popWithController:controllers successBlock:^(id result) {
        NSArray *callChainArray = (NSArray *)result;
        stackItem = [[LLModuleCallStackItem alloc] initWithModuleCallChain:callChainArray andService:serviceName andServiceType:type];
    } failureBlock:^(NSError *err) {
        stackItem = [[LLModuleCallStackItem alloc] initWithModuleCallChain:nil andService:err.localizedDescription andServiceType:LLModuleServiceTypeNone];
    }];
    
    NSLog(@"%@", stackItem);
    [self.stack pushObj:stackItem];
}

- (void)popToController:(NSString *)controller
            serviceName:(NSString *)serviceName
                popType:(LLModuleServiceType)type {
    __block LLModuleCallStackItem *stackItem = nil;
    [LLModuleTree popToController:controller successBlock:^(id result) {
        NSArray *callChainArray = (NSArray *)result;
        stackItem = [[LLModuleCallStackItem alloc] initWithModuleCallChain:callChainArray andService:serviceName andServiceType:type];
    } failureBlock:^(NSError *err) {
        stackItem = [[LLModuleCallStackItem alloc] initWithModuleCallChain:nil andService:err.localizedDescription andServiceType:LLModuleServiceTypeNone];
    }];
    
    NSLog(@"%@", stackItem);
    [self.stack pushObj:stackItem];
}

@end
