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
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(popViewControllerAnimated:)), class_getInstanceMethod([self class], @selector(my_popViewControllerAnimated:)));
}

- (nullable UIViewController *)my_popViewControllerAnimated:(BOOL)animated {
    // TODO: 优化一下查询过程
    NSString *topVC = NSStringFromClass([self.topViewController class]);
    NSString *instance = [[LLModuleProtocolManager sharedManager] getInstanceWithViewController:topVC];
    if (![LLModuleUtils isNilOrEmtpyForString:instance]) {
        [LLModuleCallStackManager popPage:instance withPopType:LLModuleTreePopTypePop];
    }
    return [self my_popViewControllerAnimated:animated];
}

@end
