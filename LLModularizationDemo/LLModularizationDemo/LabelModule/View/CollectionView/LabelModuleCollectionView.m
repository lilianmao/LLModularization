//
//  LabelModuleCollectionView.m
//  LLModularizationDemo
//
//  Created by 李林 on 1/5/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "LabelModuleCollectionView.h"
#import "LabelModuleLabelNode.h"
#import "LabelModuleLabelCategory.h"
#import "LabelModuleFlowLayout.h"
#import "LabelModuleNodeCell.h"
#import "LabelModuleNodeHeaderCell.h"
#import "LabelModuleNodeHeader.h"

#import <PureLayout/PureLayout.h>
#import "LabelModuleConsts.h"
#import "LLMacro.h"
#import "NSString+Extension.h"

@interface LabelModuleCollectionView() <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<LabelModuleLabelCategory *> *categories;
@property (nonatomic, strong) NSMutableArray<LabelModuleLabelNode *> *selectedLabels;

@end

@implementation LabelModuleCollectionView

#pragma mark - setup

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCollectionView];
    }
    return self;
}

- (void)setupCollectionView {
    LabelModuleFlowLayout *flowLayout = [[LabelModuleFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self addSubview:_collectionView];
    [_collectionView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [_collectionView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:14.f];
    [_collectionView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:30.f];
    [_collectionView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [_collectionView setContentInset:UIEdgeInsetsMake(0, 0, LABEL_FOOTER_HEADER, 0)];
    
    [_collectionView registerClass:[LabelModuleNodeCell class]
        forCellWithReuseIdentifier:LABEL_COLLECTIONVIEW_CELL_IDENTIFIER];
    [_collectionView registerClass:[LabelModuleNodeHeaderCell class] forCellWithReuseIdentifier:LABEL_COLLECTIONVIEW_HEADER_CELL_IDENTIFIER];
    [_collectionView registerClass:[LabelModuleNodeHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:LABEL_COLLECTIONVIEW_HEADER_IDENTIFIER];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.allowsMultipleSelection = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

#pragma mark - loadData

- (void)setCollectionViewCategories:(NSArray<LabelModuleLabelCategory *> *)categories {
    _categories = categories;
    
    // 获取已经设置的兴趣标签，并且更新选好了的按钮颜色。
    _selectedLabels = @[].mutableCopy;
    for(LabelModuleLabelCategory *category in categories) {
        for(LabelModuleLabelNode *label in category.nodes) {
            if (label.state == YES) {
                [_selectedLabels addObject:label];
            }
        }
    }
    if ([self.delegate respondsToSelector:@selector(getSelectedInterestLabelsCount:)]) {
        [self.delegate getSelectedInterestLabelsCount:_selectedLabels.count];
    }
    
    [_collectionView reloadData];
}

#pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if(_categories) {
        return _categories.count + 1;     // 头部定义为一个section。
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(_categories) {
        switch (section) {
            case 0:
                return 1;
                break;
            default:
                return _categories[section-1].nodes.count;
                break;
        }
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            LabelModuleNodeHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LABEL_COLLECTIONVIEW_HEADER_CELL_IDENTIFIER forIndexPath:indexPath];
            return cell;
        }
            break;
        default:
        {
            LabelModuleNodeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LABEL_COLLECTIONVIEW_CELL_IDENTIFIER forIndexPath:indexPath];
            LabelModuleNodeCellModel *cellModel = [LabelModuleNodeCellModel cellModelWith:_categories[indexPath.section-1].nodes[indexPath.row]];
            cell.cellModel = cellModel;
            return cell;
        }
            break;
    }
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (UICollectionElementKindSectionHeader == kind) {
        LabelModuleNodeHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:LABEL_COLLECTIONVIEW_HEADER_IDENTIFIER forIndexPath:indexPath];
        
        // 不同的section对应不同的颜色，6种颜色循环展示。
        NSString *imgName = [NSString stringWithFormat:@"color_%02d", (indexPath.section-1)%6];
        NSString *title = _categories[indexPath.section-1].name;
        [headerView setImageName:imgName andTitle:title];
        
        switch (indexPath.section) {
            case 1:
                [headerView setType:LabelModuleHeaderTypeNoLine];
                break;
            default:
                [headerView setType:LabelModuleHeaderTypeNormal];
                break;
        }
        
        return headerView;
    } else {
        return nil;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            // 配合collectionView的header高度(为了保证每个header高度一致)。
            CGFloat collectionViewWidth = JYFUScreenWidth - LABEL_COLLECTIONVIEW_LEFT_MARGIN - LABEL_COLLECTIONVIEW_RIGHT_MARGIN;
            return CGSizeMake(collectionViewWidth, 60.f);
        }
            break;
        default:
        {
            NSString *text = _categories[indexPath.section-1].nodes[indexPath.row].name;
            CGFloat collectionViewWidth = JYFUScreenWidth - LABEL_COLLECTIONVIEW_LEFT_MARGIN - LABEL_COLLECTIONVIEW_RIGHT_MARGIN;
            CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14.f] inSize:CGSizeMake(collectionViewWidth, LABEL_COLLECTIONVIEW_CELL_HEIGHT)];
            
            CGFloat cellMargin = 12.f;
            return CGSizeMake(size.width + cellMargin*2, LABEL_COLLECTIONVIEW_CELL_HEIGHT);
        }
            break;
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return CGSizeZero;
            break;
        default:
            return CGSizeMake(JYFUScreenWidth, LABEL_COLLECTIONVIEW_HEADER_HEIGHT);
            break;
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // 向后偏移47px（实际偏移47-14，20是collectionView左边距）。
    return UIEdgeInsetsMake(0, LABEL_COLLECTIONVIEW_LEFT_MARGIN - LABEL_COLLECTIONVIEW_SECTION_LEFT_MARGIN, 0, 0);
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            break;
        default:
            [self selectLabelNodeActionWithCollectionView:collectionView andIndexPath:indexPath];
            break;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            break;
        default:
            [self selectLabelNodeActionWithCollectionView:collectionView andIndexPath:indexPath];
            break;
    }
}

- (void)selectLabelNodeActionWithCollectionView:(UICollectionView *)collectionView
                                   andIndexPath:(NSIndexPath *)indexPath {
    LabelModuleNodeCell *cell = (LabelModuleNodeCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.state = !cell.state;
    _categories[indexPath.section-1].nodes[indexPath.row].state = !_categories[indexPath.section-1].nodes[indexPath.row].state;
    if (_categories[indexPath.section-1].nodes[indexPath.row].state) {
        [_selectedLabels addObject:_categories[indexPath.section-1].nodes[indexPath.row]];
    } else {
        [_selectedLabels removeObject:_categories[indexPath.section-1].nodes[indexPath.row]];
    }
    
    if ([self.delegate respondsToSelector:@selector(getSelectedInterestLabelsCount:)]) {
        [self.delegate getSelectedInterestLabelsCount:_selectedLabels.count];
    }
}

#pragma mark - Api

- (NSArray<LabelModuleLabelNode *> *)getSelectedLabels {
    return [_selectedLabels copy];
}

@end
