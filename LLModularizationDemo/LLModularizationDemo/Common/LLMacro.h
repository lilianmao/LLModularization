//
//  LLMacro.h
//  LLModularizationDemo
//
//  Created by 李林 on 2017/12/9.
//  Copyright © 2017年 lee. All rights reserved.
//

#ifndef LLMacro_h
#define LLMacro_h

typedef void (^LLSuccessBlock)(id result);
typedef void (^LLFailureBlock)(NSError *err);

#import "UIColor+Extension.h"

// color
#define LLURGBA(r, g, b, a)     [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define LLURGB(r, g, b)         [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define LLFColorOpacity(x,a)    [UIColor ll_colorWithRGB:x alpha:a]
#define LLFColor(x)             LLFColorOpacity(x,1)
#define LLThemeColor            LLFColor(0x3c4a55)

#endif /* LLMacro_h */
