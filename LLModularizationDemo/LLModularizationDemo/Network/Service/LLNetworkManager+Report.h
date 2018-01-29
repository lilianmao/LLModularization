//
//  LLNetworkManager+Report.h
//  LLModularizationDemo
//
//  Created by 李林 on 1/12/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "LLNetworkManager.h"

@interface LLNetworkManager (Report)

/**
 上报
 
 @param params 请求参数
 @param success 成功block
 @param failure 失败block
 */
- (void)reportWithParams:(NSDictionary *)params
                 success:(LLSuccessBlock)success
                 failure:(LLFailureBlock)failure;

@end
