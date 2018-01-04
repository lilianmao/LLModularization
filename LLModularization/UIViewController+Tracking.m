//
//  UIViewController+Tracking.m
//  modularizationDemo
//
//  Created by 李林 on 12/19/17.
//  Copyright © 2017 lee. All rights reserved.
//

#import "UIViewController+Tracking.h"
#import <objc/runtime.h>
#import "LLModuleProtocolManager.h"
#import "LLModuleCallStackManager.h"
#import "LLModuleUtils.h"

@implementation UIViewController (Tracking)

#pragma mark - Method Swizzling

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(presentViewController:animated:completion:)), class_getInstanceMethod([self class], @selector(LLModule_presentViewController:animated:completion:)));
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(dismissViewControllerAnimated:completion:)), class_getInstanceMethod([self class], @selector(LLModule_dismissViewControllerAnimated:completion:)));
}

- (void)LLModule_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^ __nullable)(void))completion NS_AVAILABLE_IOS(5_0) {
    UIViewController *callerVC = [LLModuleUtils topMostViewControllerWithRootViewController:self];
    UIViewController *calleeVC = [LLModuleUtils topMostViewControllerWithRootViewController:viewControllerToPresent];
    NSString *callerVCModule = [LLModuleUtils getModuleNameWithStr:NSStringFromClass([callerVC class])];
    NSString *calleeVCModule = [LLModuleUtils getModuleNameWithStr:NSStringFromClass([calleeVC class])];
    if (![LLModuleUtils isNilOrEmtpyForString:callerVCModule] && ![LLModuleUtils isNilOrEmtpyForString:calleeVCModule]) {
        [LLModuleCallStackManager appendCallStackItemWithCallerModule:callerVCModule callerController:NSStringFromClass([callerVC class]) calleeModule:calleeVCModule calleeController:NSStringFromClass([calleeVC class]) moduleService:@"presentViewController:animated:completion:" serviceType:LLModuleServiceTypePresent];
    }
    [self LLModule_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (void)LLModule_dismissViewControllerAnimated: (BOOL)flag completion: (void (^ __nullable)(void))completion NS_AVAILABLE_IOS(5_0) {
    NSString *topVC = NSStringFromClass([[self getPresentingViewController:self.presentingViewController] class]);
    if (topVC) {
        [LLModuleCallStackManager popToController:topVC serviceName:@"dismissViewControllerAnimated:completion:" popType:LLModuleServiceTypeDismiss];
    }
    [self LLModule_dismissViewControllerAnimated:flag completion:completion];
}

- (UIViewController *)getPresentingViewController:(UIViewController *)presentingVC {
    if ([presentingVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)presentingVC;
        return [self getPresentingViewController:tabBarController.selectedViewController];
    } else if ([presentingVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)presentingVC;
        return [self getPresentingViewController:navController.topViewController];
    } else {
        return presentingVC;
    }
}

@end
