//
//  LLNetworkResponseEntity.m
//  LLModularizationDemo
//
//  Created by 李林 on 1/12/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "LLNetworkResponseEntity.h"

@implementation LLNetworkResponseEntity

- (instancetype)initWithResponseDictionary:(NSDictionary *)responseDict {
    if (self = [super init]) {
        self.status = [[responseDict objectForKey:LLNETWORK_CODE] integerValue];
        self.message = [responseDict objectForKey:LLNETWORK_MSG];
        self.data = [responseDict objectForKey:LLNETWORK_DATA];
    }
    return self;
}

@end
