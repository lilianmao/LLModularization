//
//  LabelModuleFooterView.m
//  LLModularizationDemo
//
//  Created by 李林 on 1/5/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "LabelModuleFooterView.h"
#import <PureLayout/PureLayout.h>
#import "LLMacro.h"
#import "LabelModuleConsts.h"

static CGFloat topMargin = 30.f;

@interface LabelModuleFooterView()

@property (nonatomic, strong) UIButton *startBtn;

@end

@implementation LabelModuleFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
        [self layoutViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor clearColor];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)LLFColorOpacity(0xffffff, 0).CGColor, (__bridge id)LLFColorOpacity(0xffffff, 1).CGColor];
    gradientLayer.locations = @[@0, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = CGRectMake(0, 0, JYFUScreenWidth, 108.f);
    [self.layer addSublayer:gradientLayer];
    
    _startBtn = [[UIButton alloc] init];
    [self addSubview:_startBtn];
    [self setStartButtonType:LabelModuleFooterViewButtonTypeGray];
    [_startBtn setTitle:@"开启个性化之旅" forState:UIControlStateNormal];
    [_startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _startBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [_startBtn addTarget:self action:@selector(submitInterestLabelsAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutViews {
    _startBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    [_startBtn setTitleEdgeInsets:UIEdgeInsetsMake(16.f, 0, 0, 0)];
    
    [_startBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:topMargin];
    [_startBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_startBtn autoSetDimension:ALDimensionHeight toSize:60.f]; // 这里不做频幕适配，适配了切图有误。
    [_startBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:80.f];
    [_startBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:80.f];
}

#pragma mark - Action

- (void)submitInterestLabelsAction {
    if ([self.delegate respondsToSelector:@selector(submitInterestLabels)]) {
        [self.delegate submitInterestLabels];
    }
}

#pragma mark - Api

- (void)setStartButtonName:(NSString *)name {
    [_startBtn setTitle:name forState:UIControlStateNormal];
}

- (void)setStartButtonType:(LabelModuleFooterViewButtonType)type {
    switch (type) {
        case LabelModuleFooterViewButtonTypeGray:
        {
            UIImage *grayImage = [[UIImage imageNamed:@"button_gray"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 30) resizingMode:UIImageResizingModeTile];
            [_startBtn setBackgroundImage:grayImage forState:UIControlStateNormal];
            _startBtn.userInteractionEnabled = NO;
        }
            break;
        case LabelModuleFooterViewButtonTypePressed:
        {
            UIImage *pressedImage = [[UIImage imageNamed:@"button_pressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 30) resizingMode:UIImageResizingModeTile];
            [_startBtn setBackgroundImage:pressedImage forState:UIControlStateNormal];
            _startBtn.userInteractionEnabled = YES;
        }
            break;
        default:
            break;
    }
}

// 缩小频幕触控区域
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (point.y >= topMargin) {
        return YES;
    }
    return NO;
}

@end
