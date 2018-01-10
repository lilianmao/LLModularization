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

@interface LabelModuleLabelManager()

@property (nonatomic, assign) BOOL initialized;

@end

@implementation LabelModuleLabelManager

#pragma mark - sharedManager

+ (instancetype)sharedLabelManager {
    static dispatch_once_t onceToken;
    static LabelModuleLabelManager *sharedLabel = nil;
    dispatch_once(&onceToken, ^{
        sharedLabel = [[LabelModuleLabelManager alloc] init];
        sharedLabel.initialized = NO;
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
    if (!self.initialized) {    // 如果没有初始化过，那么新建一个table。
        __weak __typeof(self)weakSelf = self;
        [[LabelModule sharedModule] callServiceWithURL:[self generateCreateSQL_URL] parameters:nil navigationMode:LLModuleNavigationModeNone successBlock:^(id result) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.initialized = (BOOL)result;
        } failureBlock:^(NSError *err) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.initialized = NO;
        }];
    } else {
        [[LabelModule sharedModule] callServiceWithURL:[self generateTruncateSQL_URL] parameters:nil navigationMode:LLModuleNavigationModeNone successBlock:nil failureBlock:nil];
    }
    
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

- (void)loadLabelNodeFromDataBaseSuccessed:(LLSuccessBlock)success
                                  failured:(LLFailureBlock)failure {
    [[LabelModule sharedModule] callServiceWithURL:[self generateQuerySQL_URL] parameters:@{@"key": @"value"} navigationMode:LLModuleNavigationModeNone successBlock:^(id result) {
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
    [[LabelModule sharedModule] callServiceWithURL:[self generateInsertSQL_WithLabelNode:labels] parameters:nil navigationMode:LLModuleNavigationModeNone successBlock:^(id result) {
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

- (NSString *)generateQuerySQL_URL {
    NSString *labelNodeClsName = NSStringFromClass([LabelModuleLabelNode class]);
    return [NSString stringWithFormat:@"ll://operateDB/select * from %@/%@", labelNodeClsName, labelNodeClsName];
}

- (NSString *)generateInsertSQL_WithLabelNode:(NSArray<LabelModuleLabelNode *> *)labels {
    NSString *labelNodeClsName = NSStringFromClass([LabelModuleLabelNode class]);
    __block NSString *insertSQL = @"";
    [labels enumerateObjectsUsingBlock:^(LabelModuleLabelNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(labelId, state, name) VALUES(%d, %d, %@); ", labelNodeClsName, labels[idx].labelId, labels[idx].state, labels[idx].name];
        insertSQL = [insertSQL stringByAppendingString:sql];
    }];
    
    return [NSString stringWithFormat:@"ll://operateDB/%@", insertSQL];
}

- (NSString *)generateCreateSQL_URL {
    NSString *labelNodeClsName = NSStringFromClass([LabelModuleLabelNode class]);
    NSString *createSQL = [NSString stringWithFormat:@"ll://operateDB/CREATE TABLE '%@' ('labelId' INTEGER PRIMARY KEY  NOT NULL ,'state' INTEGER,'name' VARCHAR(255))/", labelNodeClsName];
    return createSQL;
}

- (NSString *)generateTruncateSQL_URL {
    NSString *labelNodeClsName = NSStringFromClass([LabelModuleLabelNode class]);
    NSString *truncateSQL = [NSString stringWithFormat:@"ll://operateDB/TRUNCATE TABLE %@", labelNodeClsName];
    return truncateSQL;
}

@end
