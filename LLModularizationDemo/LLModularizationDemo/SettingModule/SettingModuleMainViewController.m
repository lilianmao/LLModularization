//
//  SettingModuleMainViewController.m
//  LLModularizationDemo
//
//  Created by 李林 on 1/25/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "SettingModuleMainViewController.h"
#import "SettingModuleMainViewCell.h"

static NSInteger rows = 6;

@interface SettingModuleMainViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSDictionary *data;

@end

@implementation SettingModuleMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
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
    [_tableView registerClass:[SettingModuleMainViewCell class] forCellReuseIdentifier:NSStringFromClass([SettingModuleMainViewCell class])];
}

- (void)layoutViews {
    [_tableView autoPinEdgesToSuperviewEdges];
}

#pragma mark - loadData

- (void)loadData {
    self.data = @{
                  @"视频自动连续播放"           : @(YES),
                  @"允许3G/4G网络播放视频、音频" : @(NO),
                  @"允许3G/4G网络下载视频、音频" : @(NO),
                  @"允许访问用户通讯录"         : @(NO),
                  @"允许访问用户相册"           : @(YES),
                  @"允许访问用户相机"           : @(YES)
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
    SettingModuleMainViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SettingModuleMainViewCell class])];
    
    NSArray *allKeys = [self.data allKeys];
    NSString *key = [allKeys objectAtIndex:indexPath.row];
    BOOL value = [[self.data objectForKey:key] boolValue];
    [cell setCellText:key switchVal:value lineViewHidden:(indexPath.row == rows-1)];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48.f;
}

@end
