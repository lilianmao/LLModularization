//
//  LLUtils.m
//  LLModularizationDemo
//
//  Created by 李林 on 12/14/17.
//  Copyright © 2017 lee. All rights reserved.
//

#import "LLUtils.h"

@interface LLUtils()

@end

@implementation LLUtils

+ (BOOL)isNilOrEmtpyForString:(NSString *)aString {
    if ([aString isEqual:[NSNull null]] || !aString || !aString.length) {
        return YES;
    }
    return NO;
}

@end
