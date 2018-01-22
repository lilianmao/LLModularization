//
//  DataBase+LabelModuleLabelNode.m
//  LLModularizationDemo
//
//  Created by 李林 on 1/10/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "DataBase+LabelModuleLabelNode.h"
#import <FMDB/FMDB.h>

#import <MJExtension/MJExtension.h>

@implementation DataBase (LabelModuleLabelNode)

#pragma mark - get

- (NSArray<LabelModuleLabelNode *> *)LabelModuleLabelNode_getAllElementsWithSQL:(NSString *)sql {
    NSMutableArray *labels = @[].mutableCopy;
    
    if ([self.db open]) {
        FMResultSet *res = [self.db executeQuery:sql];
        
        while ([res next]) {
            LabelModuleLabelNode *labelNode = [[LabelModuleLabelNode alloc] init];
            
            labelNode.labelId = [[res stringForColumn:@"labelId"] intValue];
            labelNode.state = [[res stringForColumn:@"state"] integerValue];
            labelNode.name = [res stringForColumn:@"name"];
            
            [labels addObject:labelNode];
        }
    }
    
    [self.db close];
    
    return [labels copy];
}

#pragma mark - set

- (BOOL)LabelModuleLabelNode_setElementwithSQL:(NSString *)sql
                                      labelStr:(NSString *)labelStr {
    NSRange insertRange = [sql rangeOfString:@"insert" options:NSCaseInsensitiveSearch];
    NSRange updateRange = [sql rangeOfString:@"update" options:NSCaseInsensitiveSearch];
    NSRange deleteRange = [sql rangeOfString:@"delete" options:NSCaseInsensitiveSearch];
    
    if (insertRange.length > 0) {
        return [self LabelModuleLabelNode_insertElementsWithSQL:sql labelStr:labelStr];
    }
    if (updateRange.length > 0) {
        return [self LabelModuleLabelNode_updateElementsWithSQL:sql labelStr:labelStr];
    }
    if (deleteRange.length > 0) {
        return [self LabelModuleLabelNode_deleteElementsWithSQL:sql labelStr:labelStr];
    }
    
    return NO;
}

- (BOOL)LabelModuleLabelNode_insertElementsWithSQL:(NSString *)sql
                                          labelStr:(NSString *)labelStr {
    __block BOOL result = YES;      // 初始化设置为YES，不然&&操作全是NO。
    NSArray<LabelModuleLabelNode *> *labels = [LabelModuleLabelNode mj_objectArrayWithKeyValuesArray:labelStr];
    
    if ([self.db open]) {
        // 批量增加，加入事务。
        [self.db beginTransaction];
        BOOL isRollBack = NO;
        
        @try {
            [labels enumerateObjectsUsingBlock:^(LabelModuleLabelNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                result = result && [self.db executeUpdate:sql, @(obj.labelId), @(obj.labelId), obj.name];
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

- (BOOL)LabelModuleLabelNode_updateElementsWithSQL:(NSString *)sql
                                          labelStr:(NSString *)labelStr {
    return YES;
}

- (BOOL)LabelModuleLabelNode_deleteElementsWithSQL:(NSString *)sql
                                          labelStr:(NSString *)labelStr {
    BOOL result = NO;
    LabelModuleLabelNode *label = [LabelModuleLabelNode mj_objectWithKeyValues:labelStr];
    
    [self.db open];
    [self.db executeUpdate:sql, label.labelId];
    [self.db close];
    
    return result;
}

@end
