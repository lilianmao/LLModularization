//
//  LoginModuleMainViewController.m
//  LLModularizationDemo
//
//  Created by 李林 on 12/26/17.
//  Copyright © 2017 lee. All rights reserved.
//

#import "LoginModuleMainViewController.h"
#import "LoginModuleRegisterViewController.h"
#import "LoginModuleTableViewCell.h"

static CGFloat cellHeight = 60.f;

@interface LoginModuleMainViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *cellNames;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *registerBtn;
@property (nonatomic, strong) UIButton *loginBtn;

@end

@implementation LoginModuleMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"登录";
    
    [self setupViews];
    [self layoutViews];
    [self loadData];
}

#pragma mark - setup & layout

- (void)setupViews {
    _tableView = [[UITableView alloc] init];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[LoginModuleTableViewCell class] forCellReuseIdentifier:NSStringFromClass([LoginModuleTableViewCell class])];
    
    _messageLabel = [[UILabel alloc] init];
    [self.view addSubview:_messageLabel];
    _messageLabel.text = @"message";
    _messageLabel.font = [UIFont systemFontOfSize:20.f];
    
    _registerBtn = [[UIButton alloc] init];
    [self.view addSubview:_registerBtn];
    _registerBtn.backgroundColor = LLURGB(58, 199, 215);
    [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
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
    [_tableView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:50.f];
    [_tableView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:40.f];
    [_tableView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:40.f];
    
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 40*2-20) / 2;
    [_registerBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:40.f];
    [_registerBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_tableView withOffset:20.f];
    [_registerBtn autoSetDimensionsToSize:CGSizeMake(width, 50.f)];
    
    [_loginBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:40.f];
    [_loginBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_tableView withOffset:20.f];
    [_loginBtn autoSetDimensionsToSize:CGSizeMake(width, 50.f)];
}

- (void)loadData {
    _cellNames = @[@"手机 : +86", @"密码 :"].mutableCopy;
    [_tableView autoSetDimension:ALDimensionHeight toSize:(_cellNames.count) * cellHeight];
}

#pragma mark - UITableView DataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LoginModuleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LoginModuleTableViewCell class])];
    [cell setCellDataWithName:_cellNames[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
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

