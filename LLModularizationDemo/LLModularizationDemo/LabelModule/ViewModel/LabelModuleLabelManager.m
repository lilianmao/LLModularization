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
    if (1) {    // 本地没有，随机生成；本地存在，获取本地数据。
        if (success) {
            success([self generateLabelNode]);
            
            // temp: 临时测试
            [[LabelModule sharedModule] callServiceWithURL:@"ll://operateDB/select * from table;" parameters:@{@"key": @"value"} navigationMode:LLModuleNavigationModeNone successBlock:^(id result) {
                
            } failureBlock:^(NSError *err) {
                NSLog(@"%@", err.localizedDescription);
            }];
        }
    }
}

- (void)setInterestLabels:(NSArray<LabelModuleLabelNode *> *)labels
                successed:(LLSuccessBlock)success
                 failured:(LLFailureBlock)failure {
    if (success) {
        success(nil);
    }
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

@end
