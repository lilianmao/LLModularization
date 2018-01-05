//
//  LabelModuleFooterView.h
//  LLModularizationDemo
//
//  Created by 李林 on 1/5/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LabelModuleFooterViewButtonType) {
    LabelModuleFooterViewButtonTypeGray,      // 未按按钮
    LabelModuleFooterViewButtonTypePressed    // 按下按钮
};

@protocol LabelModuleFooterViewDelegate <NSObject>

- (void)submitInterestLabels;

@end

@interface LabelModuleFooterView : UIView

@property (nonatomic, weak) id<LabelModuleFooterViewDelegate> delegate;

- (void)setStartButtonName:(NSString *)name;

- (void)setStartButtonType:(LabelModuleFooterViewButtonType)type;

@end
