//
//  DataBase+callStack.h
//  LLModularizationDemo
//
//  Created by 李林 on 1/23/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "DataBase.h"

@class callStackSubmitModel;

@interface DataBase (callStack)

- (NSArray<callStackSubmitModel *> *)callStack_getAllElementsWithSQL:(NSString *)sql;

- (BOOL)callStack_setElementwithSQL:(NSString *)sql
                       callStackStr:(NSString *)callStack;

@end
