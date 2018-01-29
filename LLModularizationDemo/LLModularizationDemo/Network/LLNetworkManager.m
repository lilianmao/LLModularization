//
//  LLNetworkManager.m
//  LLModularizationDemo
//
//  Created by 李林 on 1/11/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "LLNetworkManager.h"
#import "LLNetworkUtils.h"
#import "Reachability.h"

static LLNetworkManager *networkManager = nil;

@implementation LLNetworkManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *baseUrlString = [LLNetworkUtils baseServerPath];
        NSURL *baseUrl = [NSURL URLWithString:baseUrlString];
        networkManager = [[LLNetworkManager alloc] initWithBaseURL:baseUrl];
        
        // 设置网络请求访问https站点
        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        policy.validatesDomainName = NO;
        policy.allowInvalidCertificates = YES;
        networkManager.securityPolicy = policy;
        networkManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    });
    return networkManager;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    if (self = [super initWithBaseURL:url]) {
        self.requestSerializer.timeoutInterval = [LLNetworkUtils timeoutInterval];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.securityPolicy.allowInvalidCertificates = YES;
        self.securityPolicy.validatesDomainName = NO;
    }
    return self;
}

#pragma mark - Invisible Get / Post

- (void)getRequestInvisiblyWithSubPath:(NSString *)subPath
                            parameters:(id)parameters
                       businessSuccess:(LLBusinessSuccessBlock)bizSuccessBlock {
    [self getRequestEntirelyWithSubPath:subPath
                             parameters:parameters
                        businessSuccess:bizSuccessBlock
                        businessFailure:nil
                         requestFailure:nil
                         eternalExecute:^(id object){}];
}

- (void)postRequestInvisiblyWithSubPath:(NSString *)subPath
                             parameters:(id)parameters
                        businessSuccess:(LLBusinessSuccessBlock)bizSuccessBlock {
    [self postRequestEntirelyWithSubPath:subPath
                              parameters:parameters
                         businessSuccess:bizSuccessBlock
                         businessFailure:nil
                          requestFailure:nil
                          eternalExecute:^(id object){}];
}

#pragma mark - Normal Get / Post

- (void)getRequestWithSubPath:(NSString *)subPath
                   parameters:(id)parameters
              businessSuccess:(LLBusinessSuccessBlock)bizSuccessBlock
              businessFailure:(LLBusinessFailureBlock)bizFailureBlock {
    [self getRequestEntirelyWithSubPath:subPath
                             parameters:parameters
                        businessSuccess:bizSuccessBlock
                        businessFailure:bizFailureBlock
                         requestFailure:nil
                         eternalExecute:nil];
}

- (void)postRequestWithSubPath:(NSString *)subPath
                    parameters:(id)parameters
               businessSuccess:(LLBusinessSuccessBlock)bizSuccessBlock
               businessFailure:(LLBusinessFailureBlock)bizFailureBlock {
    [self postRequestEntirelyWithSubPath:subPath
                              parameters:parameters
                         businessSuccess:bizSuccessBlock
                         businessFailure:bizFailureBlock
                          requestFailure:nil
                          eternalExecute:nil];
}

#pragma mark - Entire Get / Post

- (void)getRequestEntirelyWithSubPath:(NSString *)subPath
                           parameters:(id)parameters
                      businessSuccess:(LLBusinessSuccessBlock)bizSuccessBlock
                      businessFailure:(LLBusinessFailureBlock)bizFailureBlock
                       requestFailure:(LLRequestFailureBlock)reqFailureBlock
                       eternalExecute:(LLEternalExecuteBlock)eternalExecuteBlock {
    if (![self isReachable]) {
        [self dealNoNetWorking];
        if (eternalExecuteBlock) {
            eternalExecuteBlock(NETWORK_NOTREACHABLE_MSG);
        }
        return ;
    }
    
    [self setToken];
    if([self checkTokenExpired]) return;
    NSLog(@"GET DATA: %@ \n To Path %@", [self replaceUnicode:[parameters description]] , subPath);
    
    [self GET:subPath
   parameters:parameters
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
          [self handleRequestSuccessWithTask:task
                              responseObject:responseObject
                             businessSuccess:bizSuccessBlock
                             businessFailure:bizFailureBlock
                              eternalExecute:eternalExecuteBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleRequestFailureWithTask:task
                                     error:error
                            requestFailure:reqFailureBlock
                            eternalExecute:eternalExecuteBlock];
    }];
}

- (void)postRequestEntirelyWithSubPath:(NSString *)subPath
                            parameters:(id)parameters
                       businessSuccess:(LLBusinessSuccessBlock)bizSuccessBlock
                       businessFailure:(LLBusinessFailureBlock)bizFailureBlock
                        requestFailure:(LLRequestFailureBlock)reqFailureBlock
                        eternalExecute:(LLEternalExecuteBlock)eternalExecuteBlock {
    if (![self isReachable]) {
        [self dealNoNetWorking];
        if(eternalExecuteBlock)
        {
            eternalExecuteBlock(NETWORK_NOTREACHABLE_MSG);
        }
        return;
    }
    
    [self setToken];
    if([self checkTokenExpired]) return;
    NSLog(@"POST DATA: %@ \n To Path %@", [self replaceUnicode:[parameters description]] , subPath);
    
    [self POST:subPath parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [self handleRequestSuccessWithTask:task
                            responseObject:responseObject
                           businessSuccess:bizSuccessBlock
                           businessFailure:bizFailureBlock
                            eternalExecute:eternalExecuteBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleRequestFailureWithTask:task
                                     error:error
                            requestFailure:reqFailureBlock
                            eternalExecute:eternalExecuteBlock];
    }];
}

#pragma mark - Private Method

- (void)handleRequestSuccessWithTask:(NSURLSessionDataTask *)task
                      responseObject:(id)responseObject
                     businessSuccess:(LLBusinessSuccessBlock)bizSuccessBlock
                     businessFailure:(LLBusinessFailureBlock)bizFailureBlock
                      eternalExecute:(LLEternalExecuteBlock)eternalExecuteBlock {
    NSLog(@"RequestSuccess_Task_URL: %@", task.response.URL);
    NSLog(@"RequestSuccess_Response: %@", [self replaceUnicode:[responseObject description]]);
    
    LLNetworkResponseEntity *responseEntity = nil;
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        responseEntity = [[LLNetworkResponseEntity alloc] initWithResponseDictionary:responseObject];
    }
    if (responseEntity != nil) {
        switch (responseEntity.status) {
            case LLResponseStatusSuccess:
                NSAssert(bizSuccessBlock, ([NSString stringWithFormat:@"%@,%@", [[task currentRequest].URL relativeString], @"businessSuccessBlock can not be nil!"]));
                bizSuccessBlock(responseEntity);
                break;
            case LLResponseStatusFailure:
                if (bizFailureBlock) {
                    bizFailureBlock(responseEntity);
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:LL_NOTI_NETWORK_BUSINESS_FAILURE object:responseEntity.message?responseEntity.message:@"网络异常，请稍后重试"];
                }
                break;
            case LLResponseStatusTokenExpired:
                [[NSNotificationCenter defaultCenter] postNotificationName:LL_NOTI_NETWORK_TOKEN_EXPIRED object:responseEntity.message];
                break;
            default:
                if (bizFailureBlock) {
                    bizFailureBlock(responseEntity);
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:LL_NOTI_NETWORK_BUSINESS_FAILURE object:responseEntity.message?responseEntity.message:@"网络异常，请稍后重试"];
                }
                break;
        }
    }
    
    if (eternalExecuteBlock) {
        responseEntity = [[LLNetworkResponseEntity alloc] init];
        responseEntity.task = task;
        responseEntity.responseObject = responseObject;
        eternalExecuteBlock(responseEntity);
    }
}

- (void)handleRequestFailureWithTask:(NSURLSessionDataTask *)task
                               error:(NSError *)error
                      requestFailure:(LLRequestFailureBlock)reqFailureBlock
                      eternalExecute:(LLEternalExecuteBlock)eternalExecuteBlock {
    NSLog(@"RequestFailure_Task_URL: %@",task.response.URL);
    NSLog(@"RequestFailure_Error: %@",error);
    
    if (reqFailureBlock) {
        LLNetworkResponseEntity *responseEntity = [[LLNetworkResponseEntity alloc] init];
        responseEntity.task = task;
        responseEntity.error = error;
        reqFailureBlock(responseEntity);
        [[NSNotificationCenter defaultCenter] postNotificationName:LL_NOTI_NETWORK_BUSINESS_FAILURE object:responseEntity.message?responseEntity.message:@"网络异常，请稍后重试"];
    } else {
        [self dealNoNetWorking];
    }
    
    if (eternalExecuteBlock) {
        LLNetworkResponseEntity *responseEntity = [[LLNetworkResponseEntity alloc]init];
        responseEntity.task = task;
        responseEntity.error = error;
        eternalExecuteBlock(responseEntity);
        [[NSNotificationCenter defaultCenter]postNotificationName:LL_NOTI_NETWORK_BUSINESS_FAILURE object:responseEntity.message?responseEntity.message:@"网络异常,请稍后再试"];
    }
}

- (BOOL)isReachable {
    BOOL isReachable = self.reachabilityManager.reachable;
    if (!isReachable) {
        Reachability *reachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [reachability currentReachabilityStatus];
        if (networkStatus != NotReachable) {
            isReachable = YES;
        } else {
            isReachable = NO;
        }
    }
    
    return isReachable;
}

- (void)setToken {
//    if(!IS_NULL(CZ_HTMF_TOKEN)) {
//        [self.requestSerializer setValue:CZ_HTMF_TOKEN forHTTPHeaderField:CZ_HTMF_TOKEN_IDENTIFIER];
//    }
}

/**
 NSString值为Unicode格式的字符串编码(如\\u7E8C)转换成中文
 这个转换不甚理解
 
 @param unicodeStr unicodeStr
 
 @return 转换后的string
 */
- (NSString *)replaceUnicode:(NSString *)unicodeStr {
    if (![LLUtils isNilOrEmtpyForString:unicodeStr]) {
        NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
        NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
        NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
        NSString* returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
        return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
    } else {
        return nil;
    }
}

/**
 检查token是否过期
 暂时写成NO，需要对时间做本地化，然后拿当前时间比较。
 */
- (BOOL)checkTokenExpired {
    return NO;
}

#pragma mark - No Network

- (void)dealNoNetWorking {
    [[NSNotificationCenter defaultCenter]postNotificationName:LL_NOTI_NETWORK_REQUEST_FAILURE object:NETWORK_REQUESTFAILURE_MSG];
}

@end
