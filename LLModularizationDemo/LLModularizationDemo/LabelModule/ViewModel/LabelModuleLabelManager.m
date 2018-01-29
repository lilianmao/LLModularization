//
//  LabelModuleLabelManager.m
//  LLModularizationDemo
//
//  Created by 李林 on 1/5/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "LabelModuleLabelManager.h"
#import "LabelModuleLabelNode.h"
#import "LabelModuleLabelCategory.h"
#import "LabelModule.h"
#import "DataBase.h"
#import "DataBase+LabelModuleLabelNode.h"

#import <MJExtension/MJExtension.h>

@interface LabelModuleLabelManager()

@end

@implementation LabelModuleLabelManager

#pragma mark - sharedManager

+ (instancetype)sharedLabelManager {
    static dispatch_once_t onceToken;
    static LabelModuleLabelManager *sharedLabel = nil;
    dispatch_once(&onceToken, ^{
        sharedLabel = [[LabelModuleLabelManager alloc] init];
    });
    return sharedLabel;
}

#pragma mark - get & set

- (void)getInsterestLabelsSuccessed:(LLSuccessBlock)success
                           failured:(LLFailureBlock)failure {
    [self loadLabelNodeFromDataBaseSuccessed:^(id result) {
        NSArray<LabelModuleLabelNode *> *labels = (NSArray<LabelModuleLabelNode *> *)result;
        NSArray<LabelModuleLabelCategory *> *categories = [self generateLabelNode];
        if (!labels || labels.count==0) {   // 如果数据库没有数据，自动生成
            if (success) {
                success(categories);
            }
        } else {                            // 如果数据库有数据，合并数据
            categories = [self mergeLabels:labels toCategories:categories];
            if (success) {
                success(categories);
            }
        }
    } failured:^(NSError *err) {
        if (failure) {
            failure(err);
        }
    }];
}

- (void)setInterestLabels:(NSArray<LabelModuleLabelNode *> *)labels
                successed:(LLSuccessBlock)success
                 failured:(LLFailureBlock)failure {
    [self loadLabelNodeFromDataBaseSuccessed:^(id result) {
        NSArray<LabelModuleLabelNode *> *labels = (NSArray<LabelModuleLabelNode *> *)result;
        if (!labels || labels.count==0) {
            NSDictionary *params = [self generateCreateTableSQL_URL];
            [[DataBase sharedDataBase] executeUpdateSQL:params[@"sql"] tableName:nil objectStr:nil];
        } else {
            NSDictionary *params = [self generateTruncateSQL_URL];
            [[DataBase sharedDataBase] executeUpdateSQL:params[@"sql"] tableName:nil objectStr:nil];
        }
    } failured:^(NSError *err) {
        NSLog(@"error: %@", err.localizedDescription);
    }];
    
    [self saveLabelNodeToDataBaseWithLabels:labels successed:^(id result) {
        if (success) {
            success(result);
        }
    } failured:^(NSError *err) {
        if (failure) {
            failure(err);
        }
    }];
}

#pragma mark - load & save

- (void)loadLabelNodeFromDataBaseSuccessed:(LLSuccessBlock)success
                                  failured:(LLFailureBlock)failure {
    NSDictionary *params = [self generateQuerySQL_Params];
    NSArray *results = [[DataBase sharedDataBase] LabelModuleLabelNode_getAllElementsWithSQL:params[@"sql"]];
    if (results && success) {
        success(results);
    } else {
        failure(nil);
    }
}

- (void)saveLabelNodeToDataBaseWithLabels:(NSArray<LabelModuleLabelNode *> *)labels
                                successed:(LLSuccessBlock)success
                                 failured:(LLFailureBlock)failure {
    NSDictionary *params = [self generateInsertSQL_WithLabelNode:labels];
    BOOL status = [[DataBase sharedDataBase] LabelModuleLabelNode_setElementwithSQL:params[@"sql"] labelStr:params[@"objStr"]];
    if (status && success) {
        success([NSNumber numberWithBool:status]);
    } else {
        failure(nil);
    }
}

#pragma mark - mergeData

- (NSArray<LabelModuleLabelCategory *> *)mergeLabels:(NSArray<LabelModuleLabelNode *> *)labels toCategories:(NSArray<LabelModuleLabelCategory *> *)categories {
    NSMutableArray<LabelModuleLabelCategory *> *cates = [categories mutableCopy];
    
    for (int i=0; i<cates.count; i++) {
        NSMutableArray<LabelModuleLabelNode *> *nodes = [cates[i].nodes mutableCopy];
        for (int j=0; j<nodes.count; j++) {
            for (int k=0; k<labels.count; k++) {
                if (labels[k].labelId == nodes[j].labelId) {
                    nodes[j].state = labels[k].state;
                }
            }
        }
        cates[i].nodes = [nodes copy];
    }
    
    return [cates copy];
}

#pragma mark - generateURL

- (NSDictionary *)generateQuerySQL_Params {
    NSMutableDictionary *params = @{}.mutableCopy;
    NSString *labelNodeClsName = NSStringFromClass([LabelModuleLabelNode class]);
    
    params[@"sql"] = [NSString stringWithFormat:@"select * from %@", labelNodeClsName];
    params[@"tableName"] = labelNodeClsName;
    
    return [params copy];
}

- (NSDictionary *)generateInsertSQL_WithLabelNode:(NSArray<LabelModuleLabelNode *> *)labels {
    NSMutableDictionary *params = @{}.mutableCopy;
    NSString *labelNodeClsName = NSStringFromClass([LabelModuleLabelNode class]);
    
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO %@(labelId, state, name) VALUES(?, ?, ?);", labelNodeClsName];
    params[@"sql"] = insertSQL;
    params[@"objStr"] = [self formatLabels:labels];
    params[@"tableName"] = labelNodeClsName;
    
    return [params copy];
}

- (NSDictionary *)generateCreateTableSQL_URL {
    NSMutableDictionary *params = @{}.mutableCopy;
    NSString *labelNodeClsName = NSStringFromClass([LabelModuleLabelNode class]);
    
    NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE '%@' ('labelId' INTEGER PRIMARY KEY  NOT NULL ,'state' INTEGER,'name' VARCHAR(255))", labelNodeClsName];
    params[@"sql"] = createSQL;
    
    return [params copy];
}

// sqlite没有truncate，只能delete from
- (NSDictionary *)generateTruncateSQL_URL {
    NSMutableDictionary *params = @{}.mutableCopy;
    NSString *labelNodeClsName = NSStringFromClass([LabelModuleLabelNode class]);
    
    NSString *truncateSQL = [NSString stringWithFormat:@"delete from %@;", labelNodeClsName];
    params[@"sql"] = truncateSQL;
    
    return [params copy];
}

#pragma mark - Private Method

- (NSArray<LabelModuleLabelCategory *> *)generateLabelNode {
    NSMutableArray<LabelModuleLabelCategory *> *categories = @[].mutableCopy;
    
    LabelModuleLabelNode *node1 = [[LabelModuleLabelNode alloc] initLabelNodeWithLabelId:1 state:NO name:@"计算机视觉"];
    LabelModuleLabelNode *node2 = [[LabelModuleLabelNode alloc] initLabelNodeWithLabelId:2 state:NO name:@"人工智能"];
    LabelModuleLabelNode *node3 = [[LabelModuleLabelNode alloc] initLabelNodeWithLabelId:3 state:NO name:@"计算机图形学"];
    LabelModuleLabelNode *node4 = [[LabelModuleLabelNode alloc] initLabelNodeWithLabelId:4 state:NO name:@"计算机体系结构"];
    LabelModuleLabelCategory *cate1 = [[LabelModuleLabelCategory alloc] initLabelCategoryWithName:@"计算机" nodes:@[node1, node2, node3, node4]];
    
    LabelModuleLabelNode *node5 = [[LabelModuleLabelNode alloc] initLabelNodeWithLabelId:5 state:NO name:@"C++"];
    LabelModuleLabelNode *node6 = [[LabelModuleLabelNode alloc] initLabelNodeWithLabelId:6 state:NO name:@"Java"];
    LabelModuleLabelNode *node7 = [[LabelModuleLabelNode alloc] initLabelNodeWithLabelId:7 state:NO name:@"Python"];
    LabelModuleLabelNode *node8 = [[LabelModuleLabelNode alloc] initLabelNodeWithLabelId:7 state:NO name:@"Swift"];
    LabelModuleLabelNode *node9 = [[LabelModuleLabelNode alloc] initLabelNodeWithLabelId:9 state:NO name:@"Objective-C"];
    LabelModuleLabelCategory *cate2 = [[LabelModuleLabelCategory alloc] initLabelCategoryWithName:@"编程语言" nodes:@[node5, node6, node7, node8, node9]];
    
    LabelModuleLabelNode *node10 = [[LabelModuleLabelNode alloc] initLabelNodeWithLabelId:10 state:NO name:@"股票"];
    LabelModuleLabelNode *node11 = [[LabelModuleLabelNode alloc] initLabelNodeWithLabelId:11 state:NO name:@"基金"];
    LabelModuleLabelNode *node12 = [[LabelModuleLabelNode alloc] initLabelNodeWithLabelId:12 state:NO name:@"保险"];
    LabelModuleLabelCategory *cate3 = [[LabelModuleLabelCategory alloc] initLabelCategoryWithName:@"投资理财" nodes:@[node10, node11, node12]];
    
    [categories addObject:cate1];
    [categories addObject:cate2];
    [categories addObject:cate3];
    
    return [categories copy];
}

- (NSString *)formatLabels:(NSArray<LabelModuleLabelNode *> *)labels {
    NSMutableArray *pointIdTypeEntryList = [NSMutableArray array];
    for (LabelModuleLabelNode *label in labels) {
        NSDictionary *pointIdTypeEntry = @{
                                           @"labelId" : @(label.labelId),
                                           @"state" : @(label.state),
                                           @"name" : label.name
                                           };
        [pointIdTypeEntryList addObject:pointIdTypeEntry];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:pointIdTypeEntryList options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonStr;
}

@end
