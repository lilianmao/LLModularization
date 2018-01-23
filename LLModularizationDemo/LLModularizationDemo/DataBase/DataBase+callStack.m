//
//  DataBase+callStack.m
//  LLModularizationDemo
//
//  Created by 李林 on 1/23/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "DataBase+callStack.h"
#import <FMDB/FMDB.h>

#import <MJExtension/MJExtension.h>
#import "callStackSubmitModel.h"

@implementation DataBase (callStack)

#pragma mark - get

- (NSArray<callStackSubmitModel *> *)callStack_getAllElementsWithSQL:(NSString *)sql {
    NSMutableArray *models = @[].mutableCopy;
    
    if ([self.db open]) {
        FMResultSet *res = [self.db executeQuery:sql];
        
        while ([res next]) {
            callStackSubmitModel *model = [[callStackSubmitModel alloc] init];
            
            model.callStackItemId = [[res stringForColumn:@"callStackItemId"] intValue];
            model.callChain = [res stringForColumn:@"callChain"];
            model.service = [res stringForColumn:@"service"];
            model.serviceType = [[res stringForColumn:@"serviceType"] intValue];
            model.submitType = [[res stringForColumn:@"submitType"] intValue];
            model.date = [res dateForColumn:@"date"];
            
            [models addObject:model];
        }
    }
    
    [self.db close];
    
    return [models copy];
}

#pragma mark - set

- (BOOL)callStack_setElementwithSQL:(NSString *)sql
                       callStackStr:(NSString *)callStackStr {
    __block BOOL result = YES;      // 初始化设置为YES，不然&&操作全是NO。
    NSArray<callStackSubmitModel *> *models = [callStackSubmitModel mj_objectArrayWithKeyValuesArray:callStackStr];
    
    __block NSNumber *maxID = [self getMaxID];
    
    if ([self.db open]) {
        // 批量增加，加入事务。
        [self.db beginTransaction];
        BOOL isRollBack = NO;
        
        @try {
            [models enumerateObjectsUsingBlock:^(callStackSubmitModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                result = result && [self.db executeUpdate:sql, maxID, obj.callChain, obj.service, @(obj.serviceType), @(obj.submitType), obj.date];
                maxID = @([maxID integerValue] + 1);
            }];
        }
        @catch (NSException *exception) {
            isRollBack = YES;
            [self.db rollback];
        }
        @finally {
            if (!isRollBack) {
                [self.db commit];
            }
        }
    }
    [self.db close];
    
    return result;
}

- (NSNumber *)getMaxID {
    NSNumber *maxID = @(0);
    
    FMResultSet *res = [self.db executeQuery:@"SELECT * FROM callStack;"];
    //获取数据库中最大的ID
    while ([res next]) {
        if ([maxID integerValue] < [[res stringForColumn:@"callStackItemId"] integerValue]) {
            maxID = @([[res stringForColumn:@"percallStackItemIdson_id"] integerValue] ) ;
        }
        
    }
    maxID = @([maxID integerValue] + 1);
    
    return maxID;
}

@end
