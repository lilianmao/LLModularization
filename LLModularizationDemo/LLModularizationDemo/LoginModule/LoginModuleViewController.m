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
@property (nonatomic, strong) UILabel *messageLabel;

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
}

- (void)layoutViews {
    [_loginPageLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_loginPageLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    [_messageLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_messageLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_loginPageLabel withOffset:10.f];
}

@end
