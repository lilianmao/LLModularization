//
//  LLNavigationController.m
//  LLModularizationDemo
//
//  Created by 李林 on 2017/12/8.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "LLNavigationController.h"
#import "LLMacro.h"
#import "UIImage+Extension.h"

@interface LLNavigationController ()

@end

@implementation LLNavigationController

+ (void)initialize {
    [self setupTheme];
}

+ (void)setupTheme {
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBarTintColor:LLFColor(0xffffff)];       // bar color
    [bar setTintColor:[UIColor blackColor]];        // font color
    
    // 电池、wifi、时间显示白色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    // navigationBar中title的字体和颜色
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[NSForegroundColorAttributeName] = [UIColor blackColor];
    params[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    [bar setTitleTextAttributes:params];
    
    // 取出黑线
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:LLFColor(0xffffff)]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:LLThemeColor]];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if(self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

@end
