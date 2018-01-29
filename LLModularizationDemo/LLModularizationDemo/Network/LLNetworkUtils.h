//
//  LLNetworkUtils.h
//  LLModularizationDemo
//
//  Created by 李林 on 1/12/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LLServerAddressType) {
    LLServerAddressTypeDev = 0,     /* 开发环境 */
    LLServerAddressTypeTest = 1,    /* 测试环境 */
    LLServerAddressTypeDis = 2      /* 生产环境 */
};

@interface LLNetworkUtils : NSObject

/**
 baseServerSchema
 
 @return return baseServerSchema String
 */
+ (NSString *)baseServerSchema;

/**
 baseServerAddressWithType
 
 @param type server address type
 
 @return return baseServerAddress String
 */
+ (NSString *)baseServerAddressForType:(LLServerAddressType)type;

/**
 baseServerPath
 
 @return return baseServerPath String
 */
+ (NSString *)baseServerPath;

/**
 urlWithSubPath
 
 @param subPath subPath
 
 @return return url
 */
+ (NSURL *)urlWithSubPath:(NSString *)subPath;

/**
 timeoutInterval
 
 @return return timeoutInterval doubleValue
 */
+ (NSTimeInterval)timeoutInterval;

@end
