//
//  UIColor+Extension.m
//  LLModularizationDemo
//
//  Created by 李林 on 2017/12/9.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

+ (UIColor *)ll_colorWithRGB:(NSUInteger)aRGB alpha:(CGFloat)aAlpha {
    NSParameterAssert(aRGB<=0xffffff);
#if __LP64__
    aRGB = aRGB << 32 >> 32;
#endif
    unsigned int r = (unsigned int)aRGB>>16;
    unsigned int g = (unsigned int)aRGB<<16>>24;
    unsigned int b = (unsigned int)aRGB<<24>>24;
    
    return [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:aAlpha];
}

+ (UIColor *)ll_colorWithRGB:(NSUInteger)aRGB {
    return [self ll_colorWithRGB:aRGB alpha:1];
}

@end
