//
//  LabelModuleNodeCell.m
//  LLModularizationDemo
//
//  Created by 李林 on 1/5/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "LabelModuleNodeCell.h"
#import <PureLayout/PureLayout.h>
#import "LLMacro.h"

@implementation LabelModuleNodeCellModel

+ (instancetype)cellModelWith:(LabelModuleLabelNode *)label {
    LabelModuleNodeCellModel *cellModel = [[LabelModuleNodeCellModel alloc] init];
    
    cellModel.label = label;
    if (label.name) {
        cellModel.name = label.name;
    }
    cellModel.state = label.state;
    
    return cellModel;
}

@end


@interface LabelModuleNodeCell()

@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation LabelModuleNodeCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    _nameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_nameLabel];
    _nameLabel.font = [UIFont systemFontOfSize:13.f];
    _nameLabel.text = @"兴趣标签";
    [_nameLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_nameLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    self.state = NO;
}

- (void)setState:(BOOL)state {
    _state = state;
    
    if (state){
        _nameLabel.textColor = [UIColor whiteColor];
        self.backgroundColor = LLFColor(0x2CC17B);
        self.layer.borderWidth = 0.01f;
        self.layer.cornerRadius = self.frame.size.height / 2;
        self.layer.masksToBounds = YES;
    } else {
        _nameLabel.textColor = LLFColor(0x8891A7);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = LLFColor(0x99A4BF).CGColor;
        self.layer.borderWidth = 0.5f;
        self.layer.cornerRadius = self.frame.size.height / 2;
        self.layer.masksToBounds = YES;
    }
    
}

- (void)setCellModel:(LabelModuleNodeCellModel *)cellModel {
    _cellModel = cellModel;
    
    _nameLabel.text = cellModel.name;
    self.state = cellModel.state;
}

@end
