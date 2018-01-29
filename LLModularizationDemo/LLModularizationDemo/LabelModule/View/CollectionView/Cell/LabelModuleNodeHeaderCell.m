//
//  LabelModuleNodeHeaderCell.m
//  LLModularizationDemo
//
//  Created by 李林 on 1/5/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "LabelModuleNodeHeaderCell.h"
#import "LabelModuleConsts.h"

@interface LabelModuleNodeHeaderCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation LabelModuleNodeHeaderCell

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self setupViews];
        [self layoutViews];
    }
    return self;
}

- (void)setupViews {
    _titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_titleLabel];
    _titleLabel.text = @"选择你感兴趣的知识";
    _titleLabel.font = [UIFont systemFontOfSize:24.f];
    _titleLabel.textColor = LLFColor(0x333740);
    
    _contentLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_contentLabel];
    _contentLabel.text = @"至少选择1个 可随时调整";
    _contentLabel.font = [UIFont systemFontOfSize:16.f];
    _contentLabel.textColor = LLFColor(0x8891A7);
}

- (void)layoutViews {
    // 需要计算出offset，因为左右都有margin，要计算出这个频幕的中心位置在collectionView中的偏移量。
    CGFloat collectionViewWidth = JYFUScreenWidth - LABEL_COLLECTIONVIEW_LEFT_MARGIN - LABEL_COLLECTIONVIEW_RIGHT_MARGIN;
    CGFloat offset = (collectionViewWidth/2 + LABEL_COLLECTIONVIEW_LEFT_MARGIN) - (JYFUScreenWidth/2);
    
    [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:4.f];
    [_titleLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:self.contentView withOffset:-offset];
    
    [_contentLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_titleLabel withOffset:10.f];
    [_contentLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:_titleLabel];
}

@end
