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
            [[LabelModule sharedModule] callServiceWithURL:@"ll://operateDB" parameters:[self generateCreateSQL_URL] navigationMode:LLModuleNavigationModeNone successBlock:^(id result) {
                NSLog(@"result: %@", result);
            } failureBlock:^(NSError *err) {
                NSLog(@"error: %@", err.localizedDescription);
            }];
        } else {
            [[LabelModule sharedModule] callServiceWithURL:@"ll://operateDB" parameters:[self generateTruncateSQL_URL] navigationMode:LLModuleNavigationModeNone successBlock:nil failureBlock:nil];
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
    [[LabelModule sharedModule] callServiceWithURL:@"ll://operateDB" parameters:[self generateQuerySQL_Params] navigationMode:LLModuleNavigationModeNone successBlock:^(id result) {
        if (success) {
            success(result);
        }
    } failureBlock:^(NSError *err) {
        if (failure) {
            failure(err);
        }
    }];
}

- (void)saveLabelNodeToDataBaseWithLabels:(NSArray<LabelModuleLabelNode *> *)labels
                                successed:(LLSuccessBlock)success
                                 failured:(LLFailureBlock)failure {
    [[LabelModule sharedModule] callServiceWithURL:@"ll://operateDB" parameters:[self generateInsertSQL_WithLabelNode:labels] navigationMode:LLModuleNavigationModeNone successBlock:^(id result) {
        if (success) {
            success(result);
        }
    } failureBlock:^(NSError *err) {
        if (failure) {
            failure(err);
        }
    }];
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
    
    __block NSString *insertSQL = @"";
    [labels enumerateObjectsUsingBlock:^(LabelModuleLabelNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(labelId, state, name) VALUES(?, ?, ?);", labelNodeClsName];
        insertSQL = [insertSQL stringByAppendingString:sql];
    }];
    params[@"sql"] = insertSQL;
    params[@"objStr"] = [self formatLabels:labels];
    params[@"tableName"] = labelNodeClsName;
    
    return [params copy];
}

- (NSDictionary *)generateCreateSQL_URL {
    NSMutableDictionary *params = @{}.mutableCopy;
    NSString *labelNodeClsName = NSStringFromClass([LabelModuleLabelNode class]);
    
    NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE '%@' ('labelId' INTEGER PRIMARY KEY  NOT NULL ,'state' INTEGER,'name' VARCHAR(255))", labelNodeClsName];
    params[@"sql"] = createSQL;
    
    return [params copy];
}

- (NSDictionary *)generateTruncateSQL_URL {
    NSMutableDictionary *params = @{}.mutableCopy;
    NSString *labelNodeClsName = NSStringFromClass([LabelModuleLabelNode class]);
    
    NSString *truncateSQL = [NSString stringWithFormat:@"TRUNCATE TABLE %@", labelNodeClsName];
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
