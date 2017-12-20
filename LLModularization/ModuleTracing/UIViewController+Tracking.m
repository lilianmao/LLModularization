//
//  UIViewController+Tracking.m
//  modularizationDemo
//
//  Created by 李林 on 12/19/17.
//  Copyright © 2017 lee. All rights reserved.
//

#import "UIViewController+Tracking.h"
#import <objc/runtime.h>

@implementation UIViewController (Tracking)

#pragma mark - Method Swizzling
+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(presentViewController:animated:completion:)), class_getInstanceMethod([self class], @selector(LLModule_presentViewController:animated:completion:)));
}

- (void)LLModule_presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion NS_AVAILABLE_IOS(5_0) {
    
    [self LLModule_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

@end
