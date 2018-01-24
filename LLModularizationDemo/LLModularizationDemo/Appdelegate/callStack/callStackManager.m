//
//  callStackManager.m
//  LLModularizationDemo
//
//  Created by 李林 on 1/22/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "callStackManager.h"
#import <LLModularization/LLModule.h>
#import <LLModularization/LLModuleCallStackManager.h>

#import "LLNetworkManager+Report.h"
#import "DataBase+callStack.h"

@interface callStackManager()

@end

@implementation callStackManager

#pragma mark - sharedInstance

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static callStackManager *sharedManager = nil;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[callStackManager alloc] init];
    });
    
    return sharedManager;
}

#pragma mark - API

+ (void)saveCallStackWithType:(callStackSubmitType)submitType {
    [[callStackManager sharedManager] saveCallStackWithType:submitType];
}

+ (void)sendCallStack {
    [[callStackManager sharedManager] sendCallStack];
}

+ (void)sendIfNeedWhenLanuch {
    [[callStackManager sharedManager] sendIfNeedWhenLanuch];
}

- (void)saveCallStackWithType:(callStackSubmitType)submitType {
    [self loadCallStackFromDataBaseSuccessed:^(id result) {
        // table存在，无操作。
    } failured:^(NSError *err) {
        // table不存在，创建table。
        [[DataBase sharedDataBase] executeUpdateSQL:@"CREATE TABLE callStack ('callStackItemId' INTEGER PRIMARY KEY  NOT NULL ,'callChain' VARCHAR(255),'service' VARCHAR(255),'serviceType' INTEGER,'submitType' INTEGER, 'date' date)" tableName:nil objectStr:nil];
    }];
    
    NSString *submitModelsStr = [self generateSubmitModelsStrWithType:submitType];
    [[DataBase sharedDataBase] callStack_setElementwithSQL:@"INSERT INTO callStack(callStackItemId, callChain, service, serviceType, submitType, date) VALUES(?, ?, ?, ?, ?, ?);" callStackStr:submitModelsStr];
}

- (void)sendCallStack {
    [self loadCallStackFromDataBaseSuccessed:^(id result) {
        [[LLNetworkManager sharedManager] reportWithParams:@{@"callStacks": result} success:^(id result) {
            // send成功清理数据库
            [[DataBase sharedDataBase] executeUpdateSQL:@"DELETE FROM callStack;" tableName:nil objectStr:nil];
        } failure:^(NSError *err) {
            NSLog(@"failure");
        }];
    } failured:^(NSError *err) {
        NSLog(@"%@", err.localizedDescription);
    }];
}

- (void)sendIfNeedWhenLanuch {
    [self loadCallStackFromDataBaseSuccessed:^(id result) {
        NSArray *callStacks = (NSArray *)result;
        callStackSubmitModel *lastObj = (callStackSubmitModel *)[callStacks lastObject];
        if (lastObj.submitType == callStackSubmitTypeCrash) {
            [self sendCallStack];
        }
    } failured:^(NSError *err) {
        NSLog(@"failure");
    }];
}

- (void)loadCallStackFromDataBaseSuccessed:(LLBasicSuccessBlock_t)success
                                  failured:(LLBasicFailureBlock_t)failure {
    NSArray *callStacks = [[DataBase sharedDataBase] callStack_getAllElementsWithSQL:@"Select * from callStack;"];
    if (!callStacks || callStacks.count == 0) {
        if (failure) {
            failure(nil);
        }
    } else {
        if (success) {
            success(callStacks);
        }
    }
}

#pragma mark - Private Method

- (NSString *)generateSubmitModelsStrWithType:(callStackSubmitType)submitType {
    NSMutableArray<callStackSubmitModel *> *submitModels = @[].mutableCopy;
    NSArray *callStack = [[LLModule sharedInstance] getModuleCallStack];
    
    [callStack enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LLModuleCallStackItem *stackItem = (LLModuleCallStackItem *)obj;
        callStackSubmitModel *submitModel = [[callStackSubmitModel alloc] initWithCallStackItem:stackItem submitType:submitType date:[NSDate date]];
        [submitModels addObject:submitModel];
    }];
    
    return [self formatLabels:[submitModels copy]];
}

#pragma mark - Utils

- (NSString *)formatLabels:(NSArray<callStackSubmitModel *> *)models {
    NSMutableArray *pointIdTypeEntryList = @[].mutableCopy;
    for (callStackSubmitModel *model in models) {
        NSDictionary *pointIdTypeEntry = @{
                                           @"callChain"     : model.callChain,
                                           @"service"       : model.service,
                                           @"serviceType"   : @(model.serviceType),
                                           @"submitType"    : @(model.submitType),
                                           @"date"          : [LLUtils formatDate:model.date]
                                           };
        [pointIdTypeEntryList addObject:pointIdTypeEntry];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:pointIdTypeEntryList options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonStr;
}

@end
