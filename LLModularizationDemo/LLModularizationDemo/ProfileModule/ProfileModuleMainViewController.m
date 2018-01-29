//
//  ProfileModuleMainViewController.m
//  LLModularizationDemo
//
//  Created by 李林 on 1/25/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "ProfileModuleMainViewController.h"
#import "ProfileModuleMainViewCell.h"

static NSInteger rows = 3;

@interface ProfileModuleMainViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSDictionary *data;

@end

@implementation ProfileModuleMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Profile";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupViews];
    [self layoutViews];
    [self loadData];
}

#pragma mark - setupViews

- (void)setupViews {
    _tableView = [[UITableView alloc] init];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[ProfileModuleMainViewCell class] forCellReuseIdentifier:NSStringFromClass([ProfileModuleMainViewCell class])];
}

- (void)layoutViews {
    [_tableView autoPinEdgesToSuperviewEdges];
}

#pragma mark - loadData

- (void)loadData {
    self.data = @{
                  @"昵称：" : @"HZS7895李林",
                  @"性别：" : @"男",
                  @"介绍：" : @"我今年18岁"
                  };
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileModuleMainViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProfileModuleMainViewCell class])];
    
    NSArray *allKeys = [self.data allKeys];
    NSString *key = [allKeys objectAtIndex:indexPath.row];
    NSString *value = [self.data objectForKey:key];
    [cell setCellLeftLabelText:key rightLabelText:value];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48.f;
}

@end
