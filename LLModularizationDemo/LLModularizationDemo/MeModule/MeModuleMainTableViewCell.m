//
//  MeModuleMainTableViewCell.m
//  LLModularizationDemo
//
//  Created by 李林 on 12/27/17.
//  Copyright © 2017 lee. All rights reserved.
//

#import "MeModuleMainTableViewCell.h"
#import "LLMacro.h"
#import <PureLayout/PureLayout.h>

const CGFloat kLeftMargin = 20;
const CGFloat kRightMargin = 14;
static const CGFloat kTitleLeftMargin = 10;
static const CGFloat kIconImgWidth = 20;
static const CGFloat kRightArrowImgWidth = 8;
static const CGFloat kRightArrowImgHeight = 13;

@interface MeModuleMainTableViewCell()

@property (nonatomic, strong) UIImageView *leftIconImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *rightArrowImageView;

@end

@implementation MeModuleMainTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
        [self layoutViews];
    }
    return self;
}

#pragma mark - setup & layout

- (void)setupViews {
    _leftIconImgView = [[UIImageView alloc] init];
    [self.contentView addSubview:_leftIconImgView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = LLFColor(0x4A4A4A);
    _titleLabel.font = [UIFont systemFontOfSize:15.f];
    [self.contentView addSubview:_titleLabel];
    
    _rightArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right-arrow"]];
    [self.contentView addSubview:_rightArrowImageView];
}

- (void)layoutViews {
    [_leftIconImgView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_leftIconImgView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kLeftMargin];
    [_leftIconImgView autoSetDimensionsToSize:CGSizeMake(kIconImgWidth, kIconImgWidth)];
    
    [_titleLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_leftIconImgView withOffset:kTitleLeftMargin];
    
    [_rightArrowImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_rightArrowImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kRightMargin];
    [_rightArrowImageView autoSetDimensionsToSize:CGSizeMake(kRightArrowImgWidth, kRightArrowImgHeight)];
}

#pragma mark - setData

- (void)setCellDataWithImgName:(NSString *)imgName titleName:(NSString *)title {
    _leftIconImgView.image = [UIImage imageNamed:imgName];
    _titleLabel.text = title;
}

@end
