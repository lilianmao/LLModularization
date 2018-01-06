//
//  LabelModuleMainViewController.m
//  LLModularizationDemo
//
//  Created by 李林 on 1/5/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "LabelModuleMainViewController.h"
#import "LabelModuleCollectionView.h"
#import "LabelModuleFooterView.h"
#import "LabelModuleLabelNode.h"
#import "LabelModuleLabelCategory.h"
#import "LabelModuleViewModel.h"
#import "LabelModuleConsts.h"


@interface LabelModuleMainViewController () <LabelModuleCollectionViewDelegate, LabelModuleFooterViewDelegate>

@property (nonatomic, strong) LabelModuleCollectionView *labelView;
@property (nonatomic, strong) LabelModuleFooterView *footerView;
@property (nonatomic, strong) LabelModuleViewModel *viewModel;
@property (nonatomic, assign) NSInteger selectedNodeCount;

@end

@implementation LabelModuleMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupViewModel];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - setup

- (void)setupViewModel {
    _viewModel = [[LabelModuleViewModel alloc] init];
}

- (void)setupCollectionViewWithCategories:(NSArray<LabelModuleLabelCategory *> *)categories {
    _labelView = [[LabelModuleCollectionView alloc] init];
    [self.view addSubview:_labelView];
    _labelView.delegate = self;
    [_labelView setCollectionViewCategories:categories];
    
    [_labelView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:JYFUHeightTopBar];
    [_labelView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_labelView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_labelView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
}

- (void)setupFooter {
    _footerView = [[LabelModuleFooterView alloc] init];
    [self.view addSubview:_footerView];
    _footerView.delegate = self;
    if (_selectedNodeCount >= 1) {
        [_footerView setStartButtonType:LabelModuleFooterViewButtonTypePressed];
    }
    [_footerView setStartButtonName:@"选好了"];
    
    [_footerView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_footerView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_footerView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [_footerView autoSetDimension:ALDimensionHeight toSize:LABEL_FOOTER_HEADER];
}

#pragma mark - loadData

- (void)loadData {
    [_viewModel getInterestLabelsSuccessed:^(id result) {
        [self setupCollectionViewWithCategories:(NSArray<LabelModuleLabelCategory *> *)result];
        [self setupFooter];
    } failured:^(NSError *err) {
    }];
}

#pragma mark - Delegate

- (void)getSelectedInterestLabelsCount:(NSInteger)count {
    _selectedNodeCount = count;
    if (count < 1) {
        [_footerView setStartButtonType:LabelModuleFooterViewButtonTypeGray];
    } else {
        [_footerView setStartButtonType:LabelModuleFooterViewButtonTypePressed];
    }
}

- (void)submitInterestLabels {
    NSArray<LabelModuleLabelNode *> *labels = [_labelView getSelectedLabels];
    
    __weak __typeof(self)weakSelf = self;
    [_viewModel setInterestLabels:labels successed:^(id result) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.navigationController popViewControllerAnimated:YES];
    } failured:^(NSError *err) {
        [SVProgressHUD showErrorWithStatus:@"设置兴趣标签失败"];
    }];
}

#pragma mark - 频幕旋转

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
