//
//  LLModuleUtils.m
//  LLModularization
//
//  Created by 李林 on 2017/12/8.
//

#import "LLModuleUtils.h"

@interface LLModuleUtils()

@end

@implementation LLModuleUtils

+ (BOOL)isNilOrEmtpyForString:(NSString *)aString {
    if ([aString isEqual:[NSNull null]] || !aString || !aString.length) {
        return YES;
    }
    return NO;
}

@end
