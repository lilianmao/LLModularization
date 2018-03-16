//
//  LoginModuleTableViewCell.m
//  LLModularizationDemo
//
//  Created by 李林 on 3/16/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "LoginModuleTableViewCell.h"

@interface LoginModuleTableViewCell()

@property (nonatomic, strong) UILabel *textName;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation LoginModuleTableViewCell

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
    _textName = [[UILabel alloc] init];
    [self.contentView addSubview:_textName];
    _textName.text = @"Text : ";
    _textName.textColor = LLURGB(173, 177, 189);
    _textName.font = [UIFont systemFontOfSize:20.f];
    [_textName setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    
    _textField = [[UITextField alloc] init];
    [self.contentView addSubview:_textField];
    _textField.textColor = LLURGB(173, 177, 189);
    _textField.font = [UIFont systemFontOfSize:20.f];
    _textField.textAlignment = NSTextAlignmentLeft;
    _textField.userInteractionEnabled = YES;
    
    _lineView = [[UIView alloc] init];
    [self.contentView addSubview:_lineView];
    _lineView.backgroundColor = LLURGB(230, 230, 230);
}

- (void)layoutViews {
    [_textName autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_textName autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [_textName autoSetDimension:ALDimensionWidth toSize:100.f];
    // TODO: 这里约束写死了，不知道为什么不约束，UITextField会被UILabel挤没了。
    
    [_textField autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_textName withOffset:5.f];
    [_textField autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [_textField autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_textField autoSetDimension:ALDimensionHeight toSize:24.f];
    
    [_lineView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_lineView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_lineView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:15.f];
    [_lineView autoSetDimension:ALDimensionHeight toSize:1.0f];
}

#pragma mark - setData

- (void)setCellDataWithName:(NSString *)name {
    _textName.text = name;
}

@end
