//
//  callStackSubmitModel.m
//  LLModularizationDemo
//
//  Created by 李林 on 1/23/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "callStackSubmitModel.h"
#import <MJExtension/MJExtension.h>

@implementation callStackSubmitModel

MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"callChain"   : @"callChain",
             @"service"     : @"service",
             @"serviceType" : @"serviceType",
             @"submitType"  : @"submitType",
             @"date"        : @"date"
             };
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (property.type.typeClass == [NSDate class]) {
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        return [fmt dateFromString:oldValue];
    }
    
    return oldValue;
}

#pragma mark - init

- (instancetype)initWithCallStackItem:(LLModuleCallStackItem *)item
                           submitType:(callStackSubmitType)submitType
                                 date:(NSDate *)date {
    if (self = [super init]) {
        _callChain = item.moduleCallChain;
        _service = item.service;
        _serviceType = item.serviceType;
        _submitType = submitType;
        _date = date;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"id=%d, callChain=%@, service=%@, serviceType=%@, submitType=%@, date=%@",_callStackItemId, _callChain, _service, [self formatServiceType:_serviceType], [self formatSubmitType:_submitType], [LLUtils formatDate:_date]];
}

#pragma mark - format

- (NSString *)formatServiceType:(LLModuleServiceType)type {
    NSString *result = nil;
    
    switch (type) {
        case LLModuleServiceTypePush:
            result = @"Push";
            break;
        case LLModuleServiceTypePresent:
            result = @"Present";
            break;
        case LLModuleServiceTypePop:
            result = @"Pop";
            break;
        case LLModuleServiceTypeDismiss:
            result = @"Dismiss";
            break;
        case LLModuleServiceTypeBackground:
            result = @"Background";
            break;
        default:
            result = @"None";
            break;
    }
    
    return result;
}

- (NSString *)formatSubmitType:(callStackSubmitType)type {
    NSString *result = nil;
    
    switch (type) {
        case callStackSubmitTypeCrash:
            result = @"Crash";
            break;
        case callStackSubmitTypeSampling:
            result = @"Sampling";
            break;
        default:
            result = @"None";
            break;
    }
    
    return result;
}

@end
