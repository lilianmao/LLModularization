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

+ (NSString *)formatDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    return currentDateString;
}

+ (NSDate *)formatString:(NSString *)str {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *resDate = [formatter dateFromString:str];
    return resDate;
}

@end
