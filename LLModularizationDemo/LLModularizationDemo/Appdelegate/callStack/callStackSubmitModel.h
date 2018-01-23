//
//  callStackSubmitModel.h
//  LLModularizationDemo
//
//  Created by 李林 on 1/23/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LLModularization/LLModuleCallStackManager.h>

typedef NS_ENUM(NSInteger, callStackSubmitType) {
    callStackSubmitTypeCrash = 0,       // crash导致的
    callStackSubmitTypeSampling = 1,    // 采样上传数据
};

@interface callStackSubmitModel : NSObject

@property (nonatomic, assign) NSInteger callStackItemId;
@property (nonatomic, copy) NSString *callChain;
@property (nonatomic, copy) NSString *service;
@property (nonatomic, assign) LLModuleServiceType serviceType;
@property (nonatomic, assign) callStackSubmitType submitType;
@property (nonatomic, strong) NSDate *date;

- (instancetype)initWithCallStackItem:(LLModuleCallStackItem *)item
                           submitType:(callStackSubmitType)submitType
                                 date:(NSDate *)date;

@end
