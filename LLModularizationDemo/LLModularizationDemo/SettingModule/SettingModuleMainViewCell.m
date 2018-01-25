//
//  SettingModuleMainViewCell.m
//  LLModularizationDemo
//
//  Created by 李林 on 1/25/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "SettingModuleMainViewCell.h"

@interface SettingModuleMainViewCell()

@property (nonatomic, strong) UILabel *text;
@property (nonatomic, strong) UISwitch *textSwitch;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation SettingModuleMainViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
        [self layoutViews];
    }
    return self;
}

- (void)initViews {
    _text = [[UILabel alloc] init];
    [self.contentView addSubview:_text];
    _text.font = [UIFont systemFontOfSize:14.f];
    _text.text = @"开关";
    
    _textSwitch = [[UISwitch alloc] init];
    [self.contentView addSubview:_textSwitch];
    
    _lineView = [[UIView alloc] init];
    [self.contentView addSubview:_lineView];
    _lineView.backgroundColor = LLURGBA(0, 0, 0, 0.4f);
}

- (void)layoutViews {
    [_text autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20.f];
    [_text autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    [_textSwitch autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20.f];
    [_textSwitch autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    [_lineView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5.f];
    [_lineView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5.f];
    [_lineView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [_lineView autoSetDimension:ALDimensionHeight toSize:1];
}

- (void)setCellText:(NSString *)str switchVal:(BOOL)isOn lineViewHidden:(BOOL)hidden {
    _text.text = str;
    [_textSwitch setOn:isOn animated:YES];
    _lineView.hidden = hidden;
}

@end
