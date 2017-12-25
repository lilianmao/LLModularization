//
//  LLModuleNavigator.m
//  AFNetworking
//
//  Created by 李林 on 12/12/17.
//

#import "LLModuleNavigator.h"

@interface LLModuleNavigator()

@end

@implementation LLModuleNavigator

#pragma mark - sharedNavigator

+ (instancetype)sharedNavigator {
    static dispatch_once_t onceToken;
    static LLModuleNavigator *sharedNavigator = nil;
    
    dispatch_once(&onceToken, ^{
        sharedNavigator = [[LLModuleNavigator alloc] init];
    });
    
    return sharedNavigator;
}

#pragma mark - showVC

+ (NSArray<UIViewController *> *)showController:(UIViewController *)controller
                             withNavigationMode:(LLModuleNavigationMode)mode {
    if (mode == LLModuleNavigationModeNone) {
        mode = LLModuleNavigationModePush;
    }
    
    switch (mode) {
        case LLModuleNavigationModePush:
            return [[LLModuleNavigator sharedNavigator] pushViewController:controller];
            break;
        case LLModuleNavigationModePresent:
            return [[LLModuleNavigator sharedNavigator] presentViewController:controller];
            break;
        case LLModuleNavigationModeNone:
            NSLog(@"Internal error.");
            break;
        default:
            break;
    }
    return nil;
}

- (NSArray<UIViewController *> *)pushViewController:(UIViewController *)controller {
    UIViewController *topViewController = [self topMostViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    
    if ([topViewController isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)topViewController pushViewController:controller animated:YES];
    } else if (topViewController.navigationController) {
        [topViewController.navigationController pushViewController:controller animated:YES];
    } else {
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        [topViewController presentViewController:navController animated:YES completion:nil];
    }
    
    NSMutableArray *viewControllerArrays = @[].mutableCopy;
    [viewControllerArrays addObject:topViewController];
    if (topViewController.presentingViewController) {
        [viewControllerArrays addObject:topViewController.presentingViewController];
    }
    return [viewControllerArrays copy];
}

- (NSArray<UIViewController *> *)presentViewController:(UIViewController *)controller {
    UIViewController *topViewController = [self topMostViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    
    if ([topViewController isKindOfClass:[UITabBarController class]] || [topViewController isKindOfClass:[UINavigationController class]]) {
        return nil;
    }
    
    if (topViewController.presentedViewController) {
        [topViewController dismissViewControllerAnimated:NO completion:nil];
    }
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [topViewController presentViewController:navController animated:YES completion:nil];
    
    return @[topViewController];
}

#pragma mark - Private Method

- (UIViewController *)topMostViewControllerWithRootViewController:(UIViewController *)rootViewController {
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

@end
