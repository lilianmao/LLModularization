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
    [[MeModuleConnector sharedConnector] callServiceWithURL:[self generateURL] parameters:[self generateParams] navigationMode:LLModuleNavigationModePresent successBlock:^(id result) {
        // 处理你操作其他模块返回的数据。
    } failureBlock:^(NSError *err) {
        [SVProgressHUD showWithStatus:err.localizedDescription];
    }];
}

#pragma mark - Private Methods

- (NSString *)generateURL {
    NSString *username = @"1";
    NSString *password = @"2";
    
    NSString *url = [NSString stringWithFormat:@"ll://login/result?username=%@&password=%@", username, password];
    
    return url;
}

- (NSDictionary *)generateParams {
    NSMutableDictionary *params = @{}.mutableCopy;
    
    params[@"key"] = @"value";
    
    return [params copy];
}

@end
