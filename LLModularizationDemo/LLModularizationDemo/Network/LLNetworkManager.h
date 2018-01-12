//
//  LLNetworkManager.h
//  LLModularizationDemo
//
//  Created by 李林 on 1/11/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "LLNetworkAPIConstants.h"
#import "LLNetworkResponseEntity.h"

#define NETWORK_NOTREACHABLE_MSG @"No Network Connection"
#define NETWORK_REQUESTFAILURE_MSG @"请先连接网络"

@class LLNetworkResponseEntity;

// 业务block
typedef void (^LLBusinessSuccessBlock) (LLNetworkResponseEntity *bizSuccessEntity); /* 业务成功 */
typedef void (^LLBusinessFailureBlock) (LLNetworkResponseEntity *bizFailureEntity); /* 业务失败 */
typedef void (^LLRequestFailureBlock) (LLNetworkResponseEntity *reqFailureEntity); /* 网络请求失败 */
typedef void (^LLEternalExecuteBlock) (id object);   /* 无论业务成功与否，都会执行的Block */

@interface LLNetworkManager : AFHTTPSessionManager

/**
 sharedManager

 @return networkManager Singleton
 */
+ (instancetype)sharedManager;

#pragma mark - Invisible Get / Post

- (void)getRequestInvisiblyWithSubPath:(NSString *)subPath
                            parameters:(id)parameters
                       businessSuccess:(LLBusinessSuccessBlock)bizSuccessBlock;

- (void)postRequestInvisiblyWithSubPath:(NSString *)subPath
                             parameters:(id)parameters
                        businessSuccess:(LLBusinessSuccessBlock)bizSuccessBlock;

#pragma mark - Normal Get / Post

- (void)getRequestWithSubPath:(NSString *)subPath
                   parameters:(id)parameters
              businessSuccess:(LLBusinessSuccessBlock)bizSuccessBlock
              businessFailure:(LLBusinessFailureBlock)bizFailureBlock;

- (void)postRequestWithSubPath:(NSString *)subPath
                    parameters:(id)parameters
               businessSuccess:(LLBusinessSuccessBlock)bizSuccessBlock
               businessFailure:(LLBusinessFailureBlock)bizFailureBlock;

#pragma mark - Entire Get / Post

- (void)getRequestEntirelyWithSubPath:(NSString *)subPath
                           parameters:(id)parameters
                      businessSuccess:(LLBusinessSuccessBlock)bizSuccessBlock
                      businessFailure:(LLBusinessFailureBlock)bizFailureBlock
                       requestFailure:(LLRequestFailureBlock)reqFailureBlock
                       eternalExecute:(LLEternalExecuteBlock)eternalExecuteBlock;

- (void)postRequestEntirelyWithSubPath:(NSString *)subPath
                            parameters:(id)parameters
                       businessSuccess:(LLBusinessSuccessBlock)bizSuccessBlock
                       businessFailure:(LLBusinessFailureBlock)bizFailureBlock
                        requestFailure:(LLRequestFailureBlock)reqFailureBlock
                        eternalExecute:(LLEternalExecuteBlock)eternalExecuteBlock;

@end
