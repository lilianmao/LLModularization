//
//  LabelModuleLabelCategory.m
//  LLModularizationDemo
//
//  Created by 李林 on 1/5/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "LabelModuleLabelCategory.h"

@implementation LabelModuleLabelCategory

- (instancetype)initLabelCategoryWithName:(NSString *)name
                                    nodes:(NSArray<LabelModuleLabelNode *> *)nodes {
    if (self = [super init]) {
        _name = name;
        _nodes = nodes;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    LabelModuleLabelCategory *category = [[LabelModuleLabelCategory allocWithZone:zone] init];
    
    category.name = [self.name copy];
    category.nodes = [[NSArray alloc] initWithArray:self.nodes copyItems:YES];
    
    return category;
}

@end
