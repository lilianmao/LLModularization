//
//  MeModuleViewController.m
//  LLModularizationDemo
//
//  Created by 李林 on 2017/12/9.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "MeModuleViewController.h"
#import <PureLayout/PureLayout.h>
#import "LLMacro.h"

#import "LoginModuleProtocol.h"
#import "MeModuleConnector.h"

@interface MeModuleViewController ()

@property (nonatomic, strong) UIButton *loginBtn;

@end

@implementation MeModuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupViews];
    [self layoutViews];
}

#pragma mark - setup & layout

- (void)setupViews {
    _loginBtn = [[UIButton alloc] init];
    [self.view addSubview:_loginBtn];
    _loginBtn.backgroundColor = LLURGB(58, 199, 215);
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
    _loginBtn.layer.cornerRadius = 5.f;
    [_loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutViews {
    [_loginBtn autoSetDimensionsToSize:CGSizeMake(80.f, 40.f)];
    [_loginBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_loginBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
}

#pragma mark - Action

- (void)loginBtnAction {
    [[MeModuleConnector sharedConnector] callServiceWithURL:@"login" navigationMode:LLModuleNavigationModePresent successBlock:nil failureBlock:nil];
}

#pragma mark - Private Methods

- (NSDictionary *)generateParams {
    NSMutableDictionary *params = @{}.mutableCopy;
    
    params[LoginModule_UserName] = @"lilin";
    params[LoginModule_Password] = @"zhouzhou";
    
    return [params copy];
}

@end
