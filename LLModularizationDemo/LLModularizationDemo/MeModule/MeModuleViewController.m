//
//  MeModuleViewController.m
//  LLModularizationDemo
//
//  Created by 李林 on 2017/12/9.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "MeModuleViewController.h"
#import <PureLayout/PureLayout.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "LLMacro.h"

#import "MeModuleConnector.h"

@interface MeModuleViewController ()

@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *accountBtn;

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
    
    _accountBtn = [[UIButton alloc] init];
    [self.view addSubview:_accountBtn];
    _accountBtn.backgroundColor = LLURGB(58, 199, 215);
    [_accountBtn setTitle:@"获取账户数据" forState:UIControlStateNormal];
    _accountBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
    _accountBtn.layer.cornerRadius = 5.f;
    [_accountBtn addTarget:self action:@selector(accountBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutViews {
    [_loginBtn autoSetDimensionsToSize:CGSizeMake(100.f, 50.f)];
    [_loginBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_loginBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:200.f];
    
    [_accountBtn autoSetDimensionsToSize:CGSizeMake(120.f, 50.f)];
    [_accountBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_accountBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_loginBtn withOffset:50.f];
}

#pragma mark - Action

- (void)loginBtnAction {
    [[MeModuleConnector sharedConnector] callServiceWithURL:[self generateLoginURL] parameters:[self generateLoginParams] navigationMode:LLModuleNavigationModePresent successBlock:^(id result) {
        // 处理你操作其他模块返回的数据。
    } failureBlock:^(NSError *err) {
        [SVProgressHUD showErrorWithStatus:err.localizedDescription];
    }];
}

- (void)accountBtnAction {
    [[MeModuleConnector sharedConnector] callServiceWithURL:@"ll://getAccount" parameters:nil navigationMode:LLModuleNavigationModeNone successBlock:^(id result) {
        [SVProgressHUD showSuccessWithStatus:(NSString *)result];
    } failureBlock:^(NSError *err) {
        [SVProgressHUD showErrorWithStatus:err.localizedDescription];
    }];
}

#pragma mark - Private Methods

- (NSString *)generateLoginURL {
    NSString *username = @"1";
    NSString *password = @"2";
    
    NSString *url = [NSString stringWithFormat:@"ll://login/result.html?username=%@&password=%@", username, password];
    
    return url;
}

- (NSDictionary *)generateLoginParams {
    NSMutableDictionary *params = @{}.mutableCopy;
    
    params[@"key"] = @"value";
    
    return [params copy];
}

@end
