//
//  LLModuleUtils.m
//  LLModularization
//
//  Created by 李林 on 2017/12/8.
//

#import "LLModuleUtils.h"
#import <objc/runtime.h>

@interface LLModuleUtils()

@end

@implementation LLModuleUtils

+ (BOOL)isNilOrEmtpyForString:(NSString *)aString {
    if ([aString isEqual:[NSNull null]] || !aString || !aString.length) {
        return YES;
    }
    return NO;
}

+ (UIViewController *)topMostViewControllerWithRootViewController:(UIViewController *)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topMostViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)rootViewController;
        return [self topMostViewControllerWithRootViewController:navController.topViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController *presentedController = rootViewController.presentedViewController;
        return [self topMostViewControllerWithRootViewController:presentedController];
    } else {
        return rootViewController;
    }
}

+ (BOOL)checkInstance:(id)instance ifExistProperty:(NSString *)propertyName {
    const char *property = [propertyName cStringUsingEncoding:NSUTF8StringEncoding];
    Ivar ivar = class_getInstanceVariable([instance class], property);
    if (!ivar) {
        return YES;
    }
    return NO;
}

@end
