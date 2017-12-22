//
//  UIViewController+Tracking.m
//  modularizationDemo
//
//  Created by 李林 on 12/19/17.
//  Copyright © 2017 lee. All rights reserved.
//

#import "UIViewController+Tracking.h"
#import <objc/runtime.h>
//#import "LoginViewController.h"

@implementation UIViewController (Tracking)

#pragma mark - Method Swizzling

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(dismissViewControllerAnimated:completion:)), class_getInstanceMethod([self class], @selector(my_dismissViewControllerAnimated:completion:)));
}

- (void)my_dismissViewControllerAnimated: (BOOL)flag completion: (void (^ __nullable)(void))completion NS_AVAILABLE_IOS(5_0) {
//    if ([self isKindOfClass:[LoginViewController class]]) {
//        NSLog(@"loginVC dismiss.");
//    }
    [self my_dismissViewControllerAnimated:flag completion:completion];
}

@end
