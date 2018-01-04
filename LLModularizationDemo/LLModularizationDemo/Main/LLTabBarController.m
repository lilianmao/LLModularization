//
//  LLTabBarController.m
//  LLModularizationDemo
//
//  Created by 李林 on 2017/12/8.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "LLTabBarController.h"
#import "LLNavigationController.h"
#import "MeModuleHomeViewController.h"
#import "MyStudyModuleMainViewController.h"
#import "MeModuleMainViewController.h"
#import "LLMacro.h"

@interface LLTabBarController ()

@end

@implementation LLTabBarController

- (instancetype)init {
    if(self = [super init]){
        [self setup];
    }
    return self;
}

- (void)setup {
    self.view.backgroundColor = LLFColor(0xffffff);
    [self setupBarItems];
}

- (void)setupBarItems {
    MeModuleHomeViewController *home = [[MeModuleHomeViewController alloc] init];
    UIViewController *homeNav = [self addChildVcWithViewController:home name:@"首页" imageName:@"tab-home" selectedImageName:@"tab-home-hl"];
    
    MyStudyModuleMainViewController *myStudy = [[MyStudyModuleMainViewController alloc] init];
    UIViewController *myStudyNav = [self addChildVcWithViewController:myStudy name:@"我的学习" imageName:@"tab-mystudy" selectedImageName:@"tab-mystudy-hl"];
    
    MeModuleMainViewController *me = [[MeModuleMainViewController alloc] init];
    UIViewController *meNav = [self addChildVcWithViewController:me name:@"账号" imageName:@"tab-account" selectedImageName:@"tab-account-hl"];
    
    self.viewControllers =@[homeNav, meNav];
}

/*
 将tabbar控制器添加到navigation控制器，然后将添加navigation控制器到tabbar控制器中
 */
- (UIViewController *) addChildVcWithViewController:(UIViewController *)viewController name:(NSString *)name imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    
    //设置tabbarItem标题
    viewController.tabBarItem.title = name;
    viewController.tabBarItem.imageInsets = UIEdgeInsetsMake(-15, 0, 0, 0);
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = LLFColor(0x3c4a55);
    [viewController.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    NSMutableDictionary *textAttrsSelected = [NSMutableDictionary dictionary];
    textAttrsSelected[NSForegroundColorAttributeName] = LLFColor(0x2cc17b);
    [viewController.tabBarItem setTitleTextAttributes:textAttrsSelected forState:UIControlStateSelected];
    
    viewController.navigationItem.title = name;
    viewController.tabBarItem.image = [UIImage imageNamed:imageName];
    
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    
    //ios7以后的新特性，需要取消掉渲染效果才能达到想要的图片效果
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = selectedImage;
    
    //一个viewController对应一个navigation
    LLNavigationController *navController = [[LLNavigationController alloc] initWithRootViewController:viewController];
    
    return navController;
}

@end
