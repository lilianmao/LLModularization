//
//  LoginModuleMainViewController.m
//  LLModularizationDemo
//
//  Created by 李林 on 12/26/17.
//  Copyright © 2017 lee. All rights reserved.
//

#import "LoginModuleMainViewController.h"
#import "LoginModuleRegisterViewController.h"

@interface LoginModuleMainViewController ()

@property (nonatomic, strong) UILabel *loginPageLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *registerBtn;
@property (nonatomic, strong) UIButton *loginBtn;

@end

@implementation LoginModuleMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"登录";
}

- (instancetype)initWithUserName:(NSString *)username
                        password:(NSString *)password {
    if (self = [super init]) {
        [self setupViews];
        [self layoutViews];
        _messageLabel.text = [NSString stringWithFormat:@"username : %@ password : %@", username, password];
    }
    return self;
}

#pragma mark - setup & layout

- (void)setupViews {
    _loginPageLabel = [[UILabel alloc] init];
    [self.view addSubview:_loginPageLabel];
    _loginPageLabel.text = @"我是登录页";
    _loginPageLabel.font = [UIFont systemFontOfSize:20.f];
    
    _messageLabel = [[UILabel alloc] init];
    [self.view addSubview:_messageLabel];
    _messageLabel.text = @"message";
    _messageLabel.font = [UIFont systemFontOfSize:20.f];
    
    _registerBtn = [[UIButton alloc] init];
    [self.view addSubview:_registerBtn];
    _registerBtn.backgroundColor = LLURGB(58, 199, 215);
    [_registerBtn setTitle:@"注册账号" forState:UIControlStateNormal];
    _registerBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
    _registerBtn.layer.cornerRadius = 5.f;
    [_registerBtn addTarget:self action:@selector(registerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    _loginBtn = [[UIButton alloc] init];
    [self.view addSubview:_loginBtn];
    _loginBtn.backgroundColor = LLURGB(58, 199, 215);
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
    _loginBtn.layer.cornerRadius = 5.f;
    [_loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutViews {
    [_loginPageLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:120.f];
    [_loginPageLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    [_messageLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_loginPageLabel withOffset:50.f];
    [_messageLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    [_registerBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:50.f];
    [_registerBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_messageLabel withOffset:50.f];
    [_registerBtn autoSetDimensionsToSize:CGSizeMake(100.f, 50.f)];
    
    [_loginBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:50.f];
    [_loginBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_messageLabel withOffset:50.f];
    [_loginBtn autoSetDimensionsToSize:CGSizeMake(120.f, 50.f)];
}

#pragma mark - Action

- (void)registerBtnAction {
    LoginModuleRegisterViewController *registerVC = [[LoginModuleRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)loginBtnAction {
    [SVProgressHUD showSuccessWithStatus:@"登录成功"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

