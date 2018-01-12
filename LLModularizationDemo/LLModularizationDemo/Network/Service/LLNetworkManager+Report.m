//
//  LLNetworkManager+Report.m
//  LLModularizationDemo
//
//  Created by 李林 on 1/12/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "LLNetworkManager+Report.h"

@implementation LLNetworkManager (Report)

- (void)reportWithParams:(NSDictionary *)params
                 success:(LLSuccessBlock)success
                 failure:(LLFailureBlock)failure {
    [self postRequestWithSubPath:REPORT_CALLCHAIN parameters:params businessSuccess:^(LLNetworkResponseEntity *bizSuccessEntity) {
        
    } businessFailure:^(LLNetworkResponseEntity *bizFailureEntity) {
        
    }];
}

@end
