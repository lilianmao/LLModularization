//
//  UIColor+Extension.h
//  LLModularizationDemo
//
//  Created by 李林 on 2017/12/9.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

+ (UIColor *)ll_colorWithRGB:(NSUInteger)aRGB alpha:(CGFloat)aAlpha;

+ (UIColor *)ll_colorWithRGB:(NSUInteger)aRGB;

@end
