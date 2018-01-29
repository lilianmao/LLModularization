//
//  LabelModuleLabelCategory.h
//  LLModularizationDemo
//
//  Created by 李林 on 1/5/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LabelModuleLabelNode.h"

@interface LabelModuleLabelCategory : NSObject  <NSCopying>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray<LabelModuleLabelNode *> *nodes;

- (instancetype)initLabelCategoryWithName:(NSString *)name
                                    nodes:(NSArray<LabelModuleLabelNode *> *)nodes;

@end
