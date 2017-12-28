//
//  UINavigationController+Tracking.m
//  modularizationDemo
//
//  Created by 李林 on 12/21/17.
//  Copyright © 2017 lee. All rights reserved.
//

#import "UINavigationController+Tracking.h"
#import <objc/runtime.h>
#import "LLModuleCallStackManager.h"
#import "LLModuleUtils.h"
#import "LLModuleConst.h"

@implementation UINavigationController (Tracking)

#pragma mark - Method Swizzling

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(pushViewController:animated:)), class_getInstanceMethod([self class], @selector(LLModule_pushViewController:animated:)));
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(popViewControllerAnimated:)), class_getInstanceMethod([self class], @selector(LLModule_popViewControllerAnimated:)));
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(popToRootViewControllerAnimated:)), class_getInstanceMethod([self class], @selector(LLModule_popToRootViewControllerAnimated:)));
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(popToViewController:animated:)), class_getInstanceMethod([self class], @selector(LLModule_popToViewController:animated:)));
}

- (void)LLModule_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIViewController *callerVC = [LLModuleUtils topMostViewControllerWithRootViewController:self.topViewController];
    if ([LLModuleUtils checkInstance:callerVC ifExistProperty:LLModule_ModuleTag] && [LLModuleUtils checkInstance:viewController ifExistProperty:LLModule_ModuleTag]) {
        NSString *callerVCModule = [callerVC valueForKey:LLModule_ModuleTag];
        NSString *calleeVCModule = [viewController valueForKey:LLModule_ModuleTag];
        if (![LLModuleUtils isNilOrEmtpyForString:callerVCModule] && ![LLModuleUtils isNilOrEmtpyForString:calleeVCModule]) {
            [LLModuleCallStackManager appendCallStackItemWithCallerModule:callerVCModule callerController:NSStringFromClass([callerVC class]) calleeModule:calleeVCModule calleeController:NSStringFromClass([viewController class]) moduleService:@"pushViewController:animated:" serviceType:LLModuleTreeServiceTypePush];
        }
    }
    [self LLModule_pushViewController:viewController animated:animated];
}

- (nullable UIViewController *)LLModule_popViewControllerAnimated:(BOOL)animated {
    UIViewController *returnVC = [self LLModule_popViewControllerAnimated:animated];
    [LLModuleCallStackManager popWithControllers:@[NSStringFromClass([returnVC class])] serviceName:@"popViewControllerAnimated:" popType:LLModuleTreeServiceTypePop];
    return returnVC;
}

- (nullable NSArray<__kindof UIViewController *> *)LLModule_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray<UIViewController *> *viewControllers = [self LLModule_popToViewController:viewController animated:animated];
    [LLModuleCallStackManager popWithControllers:[self formatViewControllers:viewControllers] serviceName:@"popToViewController:animated:" popType:LLModuleTreeServiceTypePop];
    return viewControllers;
}

- (nullable NSArray<__kindof UIViewController *> *)LLModule_popToRootViewControllerAnimated:(BOOL)animated {
    NSArray<UIViewController *> *viewControllers = [self LLModule_popToRootViewControllerAnimated:animated];
    [LLModuleCallStackManager popWithControllers:[self formatViewControllers:viewControllers] serviceName:@"popToRootViewControllerAnimated:" popType:LLModuleTreeServiceTypePop];
    return viewControllers;
}

#pragma mark - Private Method

- (NSArray<NSString *> *)formatViewControllers:(NSArray<UIViewController *> *)controllers {
    NSMutableArray<NSString *> *controllersArray = @[].mutableCopy;
    
    [controllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [controllersArray addObject:NSStringFromClass([obj class])];
    }];
    
    return [controllersArray copy];
}

@end
