//
//  LabelModuleLabelNode.m
//  LLModularizationDemo
//
//  Created by 李林 on 1/5/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "LabelModuleLabelNode.h"

@implementation LabelModuleLabelNode

- (instancetype)initLabelNodeWithLabelId:(int64_t)labelId
                                   state:(BOOL)state
                                    name:(NSString *)name {
    if (self = [super init]) {
        _labelId = labelId;
        _state = state;
        _name = name;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    LabelModuleLabelNode *node = [[LabelModuleLabelNode allocWithZone:zone] init];
    
    node.labelId = self.labelId;
    node.name = [self.name copy];
    node.state = self.state;
    
    return node;
}

@end
