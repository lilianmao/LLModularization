//
//  ProfileModuleMainViewCell.m
//  LLModularizationDemo
//
//  Created by 李林 on 1/25/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "ProfileModuleMainViewCell.h"

@interface ProfileModuleMainViewCell()

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;

@end

@implementation ProfileModuleMainViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
        [self layoutViews];
    }
    return self;
}

- (void)initViews {
    _leftLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_leftLabel];
    _leftLabel.font = [UIFont systemFontOfSize:16.f];
    _leftLabel.text = @"leftLabel：";
    
    _rightLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_rightLabel];
    _rightLabel.font = [UIFont systemFontOfSize:16.f];
    _rightLabel.text = @"rightLabel：";
}

- (void)layoutViews {
    [_leftLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20.f];
    [_leftLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    [_rightLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_leftLabel withOffset:5.f];
    [_rightLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
}

- (void)setCellLeftLabelText:(NSString *)leftText
              rightLabelText:(NSString *)rightText {
    _leftLabel.text = leftText;
    _rightLabel.text = rightText;
}

@end
