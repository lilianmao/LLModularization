//
//  MeModuleMainViewController.m
//  LLModularizationDemo
//
//  Created by 李林 on 12/26/17.
//  Copyright © 2017 lee. All rights reserved.
//

#import "MeModuleMainViewController.h"
#import "MeModuleMainTableViewCell.h"

#import <PureLayout/PureLayout.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "LLMacro.h"

#import "MeModule.h"

static NSInteger rows = 4;

@implementation MeModuleMainModel

- (instancetype)initWithImgName:(NSString *)imgName title:(NSString *)title {
    if (self = [super init]) {
        _imgName = imgName;
        _title = title;
    }
    return self;
}

@end

@interface MeModuleMainViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray<MeModuleMainModel *> *models;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MeModuleMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupViews];
    [self layoutViews];
    [self loadData];
}

#pragma mark - Lazy Load

- (NSMutableArray *)models {
    if (!_models) {
        _models = @[].mutableCopy;
    }
    return _models;
}

#pragma mark - setup & layout

- (void)setupViews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[MeModuleMainTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MeModuleMainTableViewCell class])];
}

- (void)layoutViews {
    [_tableView autoPinEdgesToSuperviewEdges];
}

- (void)loadData {
    MeModuleMainModel *profileModel = [[MeModuleMainModel alloc] initWithImgName:@"account-profile" title:@"个人资料"];
    [self.models addObject:profileModel];
    MeModuleMainModel *interestModel = [[MeModuleMainModel alloc] initWithImgName:@"account-tag" title:@"学习兴趣"];
    [self.models addObject:interestModel];
    MeModuleMainModel *myStudyModel = [[MeModuleMainModel alloc] initWithImgName:@"account-balance" title:@"我的学习"];
    [self.models addObject:myStudyModel];
    MeModuleMainModel *settingModel = [[MeModuleMainModel alloc] initWithImgName:@"account-setting" title:@"设置"];
    [self.models addObject:settingModel];
}

#pragma mark - UITableView DataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return rows;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MeModuleMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MeModuleMainTableViewCell class])];
    [cell setCellDataWithImgName:self.models[indexPath.section].imgName titleName:self.models[indexPath.section].title];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 临时测试
    if (indexPath.section == 0) {
        [self loginBtnAction];
    } else {
        [self accountBtnAction];
    }
    CFRunLoopWakeUp(CFRunLoopGetCurrent());
}

#pragma mark - Action

- (void)loginBtnAction {
    [[MeModule sharedModule] callServiceWithURL:[self generateLoginURL] parameters:[self generateLoginParams] navigationMode:LLModuleNavigationModePresent successBlock:^(id result) {
        // 处理你操作其他模块返回的数据。
    } failureBlock:^(NSError *err) {
        [SVProgressHUD showErrorWithStatus:err.localizedDescription];
    }];
}

- (void)accountBtnAction {
    [[MeModule sharedModule] callServiceWithURL:@"ll://getAccount" parameters:nil navigationMode:LLModuleNavigationModeNone successBlock:^(id result) {
        [SVProgressHUD showSuccessWithStatus:(NSString *)result];
    } failureBlock:^(NSError *err) {
        [SVProgressHUD showErrorWithStatus:err.localizedDescription];
    }];
}

- (NSString *)getAccountDataWithParams:(NSDictionary *)params {
    NSLog(@"params : %@", params);
    return @"This is Account Data.";
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
