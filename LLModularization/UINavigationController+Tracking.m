//
//  UINavigationController+Tracking.m
//  modularizationDemo
//
//  Created by 李林 on 12/21/17.
//  Copyright © 2017 lee. All rights reserved.
//

#import "UINavigationController+Tracking.h"
#import <objc/runtime.h>
#import "LLModuleProtocolManager.h"
#import "LLModuleCallStackManager.h"
#import "LLModuleUtils.h"

@implementation UINavigationController (Tracking)

#pragma mark - Method Swizzling

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(popViewControllerAnimated:)), class_getInstanceMethod([self class], @selector(LLModule_popViewControllerAnimated:)));
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(popToRootViewControllerAnimated:)), class_getInstanceMethod([self class], @selector(LLModule_popToRootViewControllerAnimated:)));
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(popToViewController:animated:)), class_getInstanceMethod([self class], @selector(LLModule_popToViewController:animated:)));
}

- (nullable UIViewController *)LLModule_popViewControllerAnimated:(BOOL)animated {
    // TODO: 优化一下查询过程
    UIViewController *returnVC = [self LLModule_popViewControllerAnimated:animated];
    NSString *topVC = NSStringFromClass([returnVC class]);
    NSString *instance = [[LLModuleProtocolManager sharedManager] getInstanceWithViewController:topVC];
    if (![LLModuleUtils isNilOrEmtpyForString:instance]) {
        [LLModuleCallStackManager popWithPage:instance withPopType:LLModuleTreePopTypePop];
    }
    return returnVC;
}

- (nullable NSArray<__kindof UIViewController *> *)LLModule_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray<UIViewController *> *viewControllers = [self LLModule_popToViewController:viewController animated:animated];
    [self popPageWithViewControllers:viewControllers];
    return viewControllers;
}

- (nullable NSArray<__kindof UIViewController *> *)LLModule_popToRootViewControllerAnimated:(BOOL)animated {
    NSArray<UIViewController *> *viewControllers = [self LLModule_popToRootViewControllerAnimated:animated];
    [self popPageWithViewControllers:viewControllers];
    return viewControllers;
}


- (void)popPageWithViewControllers:(NSArray<UIViewController *> *)viewControllers {
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *topVC = NSStringFromClass([obj class]);
        NSString *instance = [[LLModuleProtocolManager sharedManager] getInstanceWithViewController:topVC];
        if (![LLModuleUtils isNilOrEmtpyForString:instance]) {
            if (idx == 0) {
                [LLModuleCallStackManager popWithPage:instance withPopType:LLModuleTreePopTypePop];
            } else {
                [LLModuleCallStackManager popToPage:instance withPopType:LLModuleTreePopTypePop];
            }
        }
    }];
}

@end
