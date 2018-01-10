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

// TODO: 完成SQL语句的组装，使用mjExt做模型转换
- (BOOL)LabelModuleLabelNode_setElement:(NSString *)labelStr
                                withSQL:(NSString *)sql;

@end
