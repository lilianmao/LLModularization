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
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(dismissViewControllerAnimated:completion:)), class_getInstanceMethod([self class], @selector(my_dismissViewControllerAnimated:completion:)));
}

- (void)my_dismissViewControllerAnimated: (BOOL)flag completion: (void (^ __nullable)(void))completion NS_AVAILABLE_IOS(5_0) {
    NSString *topVC = NSStringFromClass([[self getPresentingViewController:self.presentingViewController] class]);
    NSString *instance = [[LLModuleProtocolManager sharedManager] getInstanceWithViewController:topVC];
    if (![LLModuleUtils isNilOrEmtpyForString:instance]) {
        [LLModuleCallStackManager popToPage:instance withPopType:LLModuleTreePopTypeDismiss];
    }
    [self my_dismissViewControllerAnimated:flag completion:completion];
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
