//
//  LabelModuleNodeHeader.m
//  LLModularizationDemo
//
//  Created by 李林 on 1/5/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "LabelModuleNodeHeader.h"
#import "LabelModuleConsts.h"

@interface LabelModuleNodeHeader()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation LabelModuleNodeHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
        [self layoutViews];
    }
    return self;
}

- (void)setupViews {
    _lineView = [[UIView alloc] init];
    [self addSubview:_lineView];
    _lineView.backgroundColor = LLFColor(0xF2F4F7);
    
    _imgView = [[UIImageView alloc] init];
    [self addSubview:_imgView];
    
    _titleLabel = [[UILabel alloc] init];
    [self addSubview:_titleLabel];
    _titleLabel.text = @"";
    _titleLabel.font = [UIFont systemFontOfSize:18.f];
    _titleLabel.textColor = LLFColor(0x333740);
}

- (void)layoutViews {
    // 距离左边存在一个相对距离，因为section偏移了，故47-14。
    [_lineView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:18.5f];
    [_lineView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:LABEL_COLLECTIONVIEW_LEFT_MARGIN - LABEL_COLLECTIONVIEW_SECTION_LEFT_MARGIN];
    [_lineView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:25.f];
    [_lineView autoSetDimension:ALDimensionHeight toSize:1.f];
    
    [_imgView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_imgView autoSetDimensionsToSize:CGSizeMake(24.f, 24.f)];
    [_imgView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:44.f];
    
    [_titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_imgView withOffset:9.f];
    [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:42.f];
}

#pragma mark - Method

- (void)setImageName:(NSString *)imgName andTitle:(NSString *)title {
    _imgView.image = [UIImage imageNamed:imgName];
    _titleLabel.text = title;
}

- (void)setType:(LabelModuleHeaderType)type {
    _type = type;
    
    switch (type) {
        case LabelModuleHeaderTypeNormal:
            _lineView.hidden = NO;
            break;
        case LabelModuleHeaderTypeNoLine:
            _lineView.hidden = YES;
            break;
        default:
            break;
    }
}

@end
