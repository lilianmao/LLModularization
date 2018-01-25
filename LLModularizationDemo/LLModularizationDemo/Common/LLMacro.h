//
//  LLMacro.h
//  LLModularizationDemo
//
//  Created by 李林 on 2017/12/9.
//  Copyright © 2017年 lee. All rights reserved.
//

#ifndef LLMacro_h
#define LLMacro_h

typedef void (^LLBlock_t)(void);
typedef void (^LLSuccessBlock)(id result);
typedef void (^LLFailureBlock)(NSError *err);

#import "UIColor+Extension.h"
#import "AppDelegate.h"

// AppDelegate

#define APP_DELEGATE ((AppDelegate*)[UIApplication sharedApplication].delegate)

// color
#define LLURGBA(r, g, b, a)     [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define LLURGB(r, g, b)         [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define LLFColorOpacity(x,a)    [UIColor ll_colorWithRGB:x alpha:a]
#define LLFColor(x)             LLFColorOpacity(x,1)
#define LLThemeColor            LLFColor(0x3c4a55)

// screen
#define JYFUScreenHeight       [[UIScreen mainScreen] bounds].size.height
#define JYFUScreenWidth        [[UIScreen mainScreen] bounds].size.width
#define JYFUHeightNavBar          44
#define JYFUHeightSystemStatus    20
#define JYFUHeightTopBar          (JYFUHeightNavBar + JYFUHeightSystemStatus)   //status bar和nav bar高度

// network
#define LL_NOTI_NETWORK_REQUEST_FAILURE     @"LL_NOTI_NETWORK_REQUEST_FAILURE"
#define LL_NOTI_NETWORK_BUSINESS_FAILURE    @"LL_NOTI_NETWORK_BUSINESS_FAILURE"
#define LL_NOTI_NETWORK_TOKEN_EXPIRED       @"LL_NOTI_NETWORK_TOKEN_EXPIRED"

#endif /* LLMacro_h */
