//
//  LLModuleNavigator.m
//  AFNetworking
//
//  Created by 李林 on 12/12/17.
//

#import "LLModuleNavigator.h"
#import "LLModuleUtils.h"

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

+ (void)showController:(UIViewController *)controller
    withNavigationMode:(LLModuleNavigationMode)mode {
    if (mode == LLModuleNavigationModeNone) {
        mode = LLModuleNavigationModePush;
    }
    
    switch (mode) {
        case LLModuleNavigationModePush:
            [[LLModuleNavigator sharedNavigator] pushViewController:controller];
            break;
        case LLModuleNavigationModePresent:
            [[LLModuleNavigator sharedNavigator] presentViewController:controller];
            break;
        case LLModuleNavigationModeNone:
            NSLog(@"Internal error.");
            break;
        default:
            break;
    }
}

- (void)pushViewController:(UIViewController *)controller {
    UIViewController *topViewController = [LLModuleUtils topMostViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    
    if ([topViewController isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)topViewController pushViewController:controller animated:YES];
    } else if (topViewController.navigationController) {
        [topViewController.navigationController pushViewController:controller animated:YES];
    } else {
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        [topViewController presentViewController:navController animated:YES completion:nil];
    }
}

- (void)presentViewController:(UIViewController *)controller {
    UIViewController *topViewController = [LLModuleUtils topMostViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    
    if ([topViewController isKindOfClass:[UITabBarController class]] || [topViewController isKindOfClass:[UINavigationController class]]) {
        return ;
    }
    
    if (topViewController.presentedViewController) {
        [topViewController dismissViewControllerAnimated:NO completion:nil];
    }
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [topViewController presentViewController:navController animated:YES completion:nil];
}

@end
