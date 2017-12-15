//
//  LLModuleURLRoutes.h
//  AFNetworking
//
//  Created by 李林 on 12/14/17.
//

#import <Foundation/Foundation.h>
#import "LLModuleConst.h"

extern NSString *const LLRoutesrURL;
extern NSString *const LLRoutesStatus;
extern NSString *const LLRoutesService;
extern NSString *const LLRoutesParameters;

@interface LLModuleURLRoutes : NSObject

/**
 给url模式注册一个Service
 */
+ (void)registerURLPattern:(NSString *)urlPattern toService:(NSString *)serviceName;

/**
 取消某个URL的注册
 */
+ (void)deregisterURLPattern:(NSString *)urlPattern;


/**
 打开一个URL

 @param url 传入需要解析的URL
 @return 返回一个字典（解析是否成功+URL对应的Service+params）
 {
    @"LLRoutesStatus" : @"YES"
    @"LLRoutesService" : @"serviceName"
    @"LLRoutesParameters" : NSDictionary
 }
 {
    @"LLRoutesStatus" : @"NO"
 }
 */
+ (NSDictionary *)openURL:(NSString *)url;


/**
 打开一个URL

 @param url 传入需要解析的URL
 @param userInfo 传入的参数（主要是一些对象参数，URL无法携带）
 */
+ (NSDictionary *)openURL:(NSString *)url
             withUserInfo:(NSDictionary *)userInfo;

@end
