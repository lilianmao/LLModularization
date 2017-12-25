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
#import "RegisterViewController.h"

@interface LoginModuleViewController ()

@property (nonatomic, strong) UILabel *loginPageLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *registerBtn;
@property (nonatomic, strong) UIButton *forgetPwdBtn;

@end

@implementation LoginModuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"登录";
    
    [self setupViews];
    [self layoutViews];
}

- (void)updateWithUserName:(NSString *)username
                  password:(NSString *)password {
    _messageLabel.text = [NSString stringWithFormat:@"username:%@ password:%@", username, password];
}

#pragma mark - setup & layout

- (void)setupViews {
    _loginPageLabel = [[UILabel alloc] init];
    [self.view addSubview:_loginPageLabel];
    _loginPageLabel.text = @"我是登录页";
    _loginPageLabel.font = [UIFont systemFontOfSize:20.f];
    
    _messageLabel = [[UILabel alloc] init];
    [self.view addSubview:_messageLabel];
    _messageLabel.text = @"";
    _messageLabel.font = [UIFont systemFontOfSize:20.f];
    
    _registerBtn = [[UIButton alloc] init];
    [self.view addSubview:_registerBtn];
    _registerBtn.backgroundColor = LLURGB(58, 199, 215);
    [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    _registerBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
    _registerBtn.layer.cornerRadius = 5.f;
    [_registerBtn addTarget:self action:@selector(registerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    _forgetPwdBtn = [[UIButton alloc] init];
    [self.view addSubview:_forgetPwdBtn];
    _forgetPwdBtn.backgroundColor = LLURGB(58, 199, 215);
    [_forgetPwdBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    _forgetPwdBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
    _forgetPwdBtn.layer.cornerRadius = 5.f;
    [_forgetPwdBtn addTarget:self action:@selector(forgetPwdBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutViews {
    [_loginPageLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:200.f];
    [_loginPageLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    [_messageLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_messageLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_loginPageLabel withOffset:10.f];
    
    [_registerBtn autoSetDimensionsToSize:CGSizeMake(100.f, 50.f)];
    [_registerBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_registerBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_loginPageLabel withOffset:50.f];
    
    [_forgetPwdBtn autoSetDimensionsToSize:CGSizeMake(120.f, 50.f)];
    [_forgetPwdBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_forgetPwdBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_registerBtn withOffset:50.f];
}

#pragma mark - Action

- (void)registerBtnAction {
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)forgetPwdBtnAction {
    
}

@end
