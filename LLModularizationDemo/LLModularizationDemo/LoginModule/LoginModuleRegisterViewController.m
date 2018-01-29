//
//  LoginModuleRegisterViewController.m
//  LLModularizationDemo
//
//  Created by 李林 on 12/25/17.
//  Copyright © 2017 lee. All rights reserved.
//

#import "LoginModuleRegisterViewController.h"

@interface LoginModuleRegisterViewController ()

@property (nonatomic, strong) UILabel *registerPageLabel;
@property (nonatomic, strong) UIButton *registerBtn;

@end

@implementation LoginModuleRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupViews];
    [self layoutViews];
}

#pragma mark - setup & layout

- (void)setupViews {
    _registerPageLabel = [[UILabel alloc] init];
    [self.view addSubview:_registerPageLabel];
    _registerPageLabel.text = @"我是注册页";
    _registerPageLabel.font = [UIFont systemFontOfSize:20.f];
    
    _registerBtn = [[UIButton alloc] init];
    [self.view addSubview:_registerBtn];
    _registerBtn.backgroundColor = LLURGB(58, 199, 215);
    [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    _registerBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
    _registerBtn.layer.cornerRadius = 5.f;
    [_registerBtn addTarget:self action:@selector(registerBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutViews {
    [_registerPageLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:200.f];
    [_registerPageLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    [_registerBtn autoSetDimensionsToSize:CGSizeMake(100.f, 50.f)];
    [_registerBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_registerBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_registerPageLabel withOffset:50.f];
}

#pragma mark - Action

- (void)registerBtnAction {
    [SVProgressHUD showSuccessWithStatus:@"注册成功"];
    [self dismissViewControllerAnimated:YES completion:nil];
////    [self.navigationController popToRootViewControllerAnimated:YES];
//    NSArray *viewControllers = self.navigationController.viewControllers;
//    [self.navigationController popToViewController:[viewControllers objectAtIndex:1] animated:YES];
}

@end
