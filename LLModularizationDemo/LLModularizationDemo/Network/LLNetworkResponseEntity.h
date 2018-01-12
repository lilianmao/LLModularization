//
//  LLNetworkResponseEntity.h
//  LLModularizationDemo
//
//  Created by 李林 on 1/12/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLNetworkAPIConstants.h"

@interface LLNetworkResponseEntity : NSObject

#pragma mark - Success Response

@property (nonatomic, assign) LLResponseStatus status;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) id data;

- (instancetype)initWithResponseDictionary:(NSDictionary *)responseDict;

#pragma mark - Failure Response

@property (nonatomic, strong) NSURLSessionDataTask *task;
@property (nonatomic, strong) NSError *error;

#pragma mark - Eternal Execute Response Property
@property (strong, nonatomic) id responseObject;

@end
