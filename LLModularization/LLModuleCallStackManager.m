//
//  LLModuleCallStackManager.m
//  LLModularization
//
//  Created by 李林 on 12/19/17.
//

#import "LLModuleCallStackManager.h"
#import "LLModuleUtils.h"
#import "StackForNSObject.h"

@interface LLModuleCallStackItem()

@property (nonatomic, strong) id<LLModuleProtocol> moduleConnector;
@property (nonatomic, copy) NSString *moduleClass;
@property (nonatomic, copy) NSString *moduleMethod;

@end

@implementation LLModuleCallStackItem

- (instancetype)initWithModuleConnector:(id<LLModuleProtocol>)connector
                            moduleClass:(NSString *)moduleClass
                           moduleMethod:(NSString *)moduleMethod {
    if (self = [super init]) {
        _moduleConnector = connector;
        _moduleClass = moduleClass;
        _moduleMethod = moduleMethod;
    }
    return self;
}

- (NSString *)description {
    NSString *itemStr = [NSString stringWithFormat:@"<LLModuleCallStackItem: connector = %@ moduleClass = %@ moduleMethod = %@>", _moduleConnector, _moduleClass, _moduleMethod];
    return itemStr;
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

+ (void)appendCallStackItemWithCallConnector:(id<LLModuleProtocol>)connector
                                 moduleClass:(NSString *)moduleClass
                                moduleMethod:(NSString *)moduleMethod {
    [[LLModuleCallStackManager sharedManager] appendCallStackItemWithCallConnector:connector moduleClass:moduleClass moduleMethod:moduleMethod];
}

#pragma mark - Private Method

- (NSArray *)getModuleCallStack {
    return [self.stack getAllObjects];
}

- (void)appendCallStackItemWithCallConnector:(id<LLModuleProtocol>)connector
                                 moduleClass:(NSString *)moduleClass
                                moduleMethod:(NSString *)moduleMethod {
    if (!connector || [LLModuleUtils isNilOrEmtpyForString:moduleClass] || [LLModuleUtils isNilOrEmtpyForString:moduleMethod]) {
        NSLog(@"Append Failured. Connector or moduleClass or moduleMethod is nil.");
        return ;
    }
    
    LLModuleCallStackItem *item = [[LLModuleCallStackItem alloc] initWithModuleConnector:connector moduleClass:moduleClass moduleMethod:moduleMethod];
    
    [self.stack pushObj:item];
    
}

#pragma mark - Utils

@end

