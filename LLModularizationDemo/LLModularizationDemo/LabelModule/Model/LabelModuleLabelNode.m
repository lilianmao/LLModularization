//
//  LabelModuleLabelNode.m
//  LLModularizationDemo
//
//  Created by 李林 on 1/5/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "LabelModuleLabelNode.h"

/**
 * 注意：协议对象中对协议中定义的property需要提供setter或getter方法；其实就是协议中定义setter和getter方法，必须在协议对象中来实现；
 */
@implementation LabelModuleLabelNode

@synthesize labelId = _labelId;
@synthesize state = _state;
@synthesize name = _name;

-(nonnull NSString *)description {
    NSString *description = [NSString stringWithFormat:@"LabelModuleLabelNode:labelId = %d, state = %d, name = %@", self.labelId, self.state, self.name];
    return description;
}

- (nonnull instancetype)initLabelNodeWithLabelId:(int)labelId
                                           state:(BOOL)state
                                            name:(nonnull NSString *)name {
    if (self = [super init]) {
        self.labelId = labelId;
        self.state = state;
        self.name = name;
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
