//
//  LLNetworkUtils.m
//  LLModularizationDemo
//
//  Created by 李林 on 1/12/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "LLNetworkUtils.h"

static NSString *const kConfig  = @"LLNetworkConfig";   /* 配置文件名 */
static NSString *const kPlist   = @"plist";             /* 配置文件类型 */

static NSString *const kBaseServerSchema        = @"Base Server Schema";    /* <LLNetworkConfig.plish> 服务器Schema键值 */
static NSString *const kBaseServerAddressDev    = @"Base Server Address Dev";   /* <LLNetworkConfig.plish> 开发环境键值 */
static NSString *const kBaseServerAddressTest   = @"Base Server Address Test";  /* <LLNetworkConfig.plish> 测试环境键值 */
static NSString *const kBaseServerAddressDis    = @"Base Server Address Dis";   /* <LLNetworkConfig.plish> 生产环境键值 */
static NSString *const kTimeoutInterval         = @"Timeout Interval";      /* <LLNetworkConfig.plish> 网络访问时限键值 */

@implementation LLNetworkUtils

+ (NSString *)baseServerSchema {
    NSString *baseServierSchema = [self readConfigObjectForKey:kBaseServerSchema];
    
    return baseServierSchema;
}

+ (NSString *)baseServerAddressForType:(LLServerAddressType)type {
    NSString *baseServerAddress;
    
    switch (type) {
        case LLServerAddressTypeDev:
            baseServerAddress = [self readConfigObjectForKey:kBaseServerAddressDev];
            break;
        case LLServerAddressTypeTest:
            baseServerAddress = [self readConfigObjectForKey:kBaseServerAddressTest];
            break;
        case LLServerAddressTypeDis:
            baseServerAddress = [self readConfigObjectForKey:kBaseServerAddressDis];
            break;
        default:
            break;
    }
    
    return baseServerAddress;
}

+ (NSString *)baseServerPath {
    LLServerAddressType type = LLServerAddressTypeTest;
    NSString *baseServerSchema = [self baseServerSchema];
    NSString *baseServerAddress = [self baseServerAddressForType:type];
    NSString *baseServerPath = [NSString stringWithFormat:@"%@%@", baseServerSchema, baseServerAddress];
    
    return baseServerPath;
}

// 组合scheme+serverAddress+subPath，类似于: http://127.0.0.1/getElement
+ (NSURL *)urlWithSubPath:(NSString *)subPath {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self baseServerPath], subPath];
    NSURL *url = [NSURL URLWithString:urlString];
    
    return url;
}

+ (NSTimeInterval)timeoutInterval {
    NSTimeInterval timeoutInterval = [[self readConfigObjectForKey:kTimeoutInterval] doubleValue];
    
    return timeoutInterval;
}

#pragma mark - Private Method

+ (id)readConfigObjectForKey:(NSString *)key {
    NSString *path = [[NSBundle mainBundle] pathForResource:kConfig ofType:kPlist];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    id value = [dic objectForKey:key];
    
    return value;
}

@end
