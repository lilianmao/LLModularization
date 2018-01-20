//
//  LLNetworkAPIConstants.h
//  LLModularizationDemo
//
//  Created by 李林 on 1/12/18.
//  Copyright © 2018 lee. All rights reserved.
//

#ifndef LLNetworkAPIConstants_h
#define LLNetworkAPIConstants_h

#pragma mark - Consts for Network
static NSString *const LLNETWORK_CODE = @"code";    /* return code key */
static NSString *const LLNETWORK_DATA = @"map";     /* return data key */
static NSString *const LLNETWORK_MSG  = @"message"; /* return message key */

typedef NS_ENUM(NSInteger, LLResponseStatus) {
    LLResponseStatusSuccess         = 0,    /* 业务成功 */
    LLResponseStatusFailure         = 1,    /* 业务失败 */
    LLResponseStatusTokenExpired    = 201,  /* 授权过期 */
};

#pragma mark - report

static NSString *const REPORT_CALLCHAIN           = @"/callStack/postCallStack";  // report

#endif /* LLNetworkAPIConstants_h */
