//
//  DataBase+LabelModuleLabelNode.h
//  LLModularizationDemo
//
//  Created by 李林 on 1/10/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "DataBase.h"
#import "LabelModuleLabelNode.h"

@interface DataBase (LabelModuleLabelNode)

- (NSArray<LabelModuleLabelNode *> *)LabelModuleLabelNode_getAllElementsWithSQL:(NSString *)sql;

- (BOOL)LabelModuleLabelNode_setElementwithSQL:(NSString *)sql
                                      labelStr:(NSString *)labelStr;

@end
