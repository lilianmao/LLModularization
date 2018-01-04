//
//  LoginModuleRegisterViewController.m
//  LLModularizationDemo
//
//  Created by 李林 on 12/25/17.
//  Copyright © 2017 lee. All rights reserved.
//

#import "LoginModuleRegisterViewController.h"
#import <PureLayout/PureLayout.h>
#import "LLMacro.h"

@interface LoginModuleRegisterViewController ()

@property (nonatomic, strong) UIButton *dismissBtn;

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
    _dismissBtn = [[UIButton alloc] init];
    [self.view addSubview:_dismissBtn];
    _dismissBtn.backgroundColor = LLURGB(58, 199, 215);
    [_dismissBtn setTitle:@"dismiss" forState:UIControlStateNormal];
    _dismissBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
    _dismissBtn.layer.cornerRadius = 5.f;
    [_dismissBtn addTarget:self action:@selector(dismissBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutViews {
    [_dismissBtn autoSetDimensionsToSize:CGSizeMake(100.f, 50.f)];
    [_dismissBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_dismissBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:200.f];
}

#pragma mark - Action

- (void)dismissBtnAction {
    [self dismissViewControllerAnimated:YES completion:nil];
////    [self.navigationController popToRootViewControllerAnimated:YES];
//    NSArray *viewControllers = self.navigationController.viewControllers;
//    [self.navigationController popToViewController:[viewControllers objectAtIndex:1] animated:YES];
}

@end
