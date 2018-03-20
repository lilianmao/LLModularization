//
//  LLModuleUtils.h
//  LLModularization
//
//  Created by 李林 on 2017/12/8.
//

#import <Foundation/Foundation.h>

@interface LLModuleUtils : NSObject

+ (void)recordNowTime;

+ (BOOL)isNilOrEmtpyForString:(NSString *)aString;

+ (UIViewController *)topMostViewControllerWithRootViewController:(UIViewController *)rootViewController;

+ (BOOL)checkInstance:(id)instance ifExistProperty:(NSString *)propertyName;

+ (NSString *)getModuleNameWithStr:(NSString *)str;

@end
