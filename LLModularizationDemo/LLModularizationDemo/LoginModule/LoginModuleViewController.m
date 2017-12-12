//
//  LoginModuleViewController.m
//  LLModularizationDemo
//
//  Created by 李林 on 2017/12/8.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "LoginModuleViewController.h"
#import <PureLayout/PureLayout.h>
#import "LLMacro.h"

@interface LoginModuleViewController ()

@property (nonatomic, strong) UILabel *loginPageLabel;

@end

@implementation LoginModuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"登录";
    
    [self setupViews];
    [self layoutViews];
}

#pragma mark - setup & layout

- (void)setupViews {
    _loginPageLabel = [[UILabel alloc] init];
    [self.view addSubview:_loginPageLabel];
    _loginPageLabel.text = @"我是登录页";
    _loginPageLabel.font = [UIFont systemFontOfSize:20.f];
}

- (void)layoutViews {
    [_loginPageLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_loginPageLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
}

@end
