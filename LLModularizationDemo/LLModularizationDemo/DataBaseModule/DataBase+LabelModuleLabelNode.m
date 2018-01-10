//
//  DataBase+LabelModuleLabelNode.m
//  LLModularizationDemo
//
//  Created by 李林 on 1/10/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "DataBase+LabelModuleLabelNode.h"
#import <FMDB/FMDB.h>

@implementation DataBase (LabelModuleLabelNode)

- (NSArray<LabelModuleLabelNode *> *)LabelModuleLabelNode_getAllElementsWithSQL:(NSString *)sql {
    NSMutableArray *labels = @[].mutableCopy;
    
    [self.db open];
    
    FMResultSet *res = [self.db executeQuery:sql];
    
    while ([res next]) {
        LabelModuleLabelNode *labelNode = [[LabelModuleLabelNode alloc] init];
        
        labelNode.labelId = [[res stringForColumn:@"labelId"] intValue];
        labelNode.state = [[res stringForColumn:@"state"] integerValue];
        labelNode.name = [res stringForColumn:@"name"];
        
        [labels addObject:labelNode];
    }
    
    [self.db close];
    
    return [labels copy];
}

- (BOOL)LabelModuleLabelNode_setElement:(NSString *)labelStr
                                withSQL:(NSString *)sql {
    return YES;
}

- (BOOL)LabelModuleLabelNode_insertElementsWithSQL:(NSString *)sql {
    return YES;
}

- (BOOL)LabelModuleLabelNode_updateElementsWithSQL:(NSString *)sql {
    return YES;
}

- (BOOL)LabelModuleLabelNode_deleteElementsWithSQL:(NSString *)sql {
    return YES;
}

@end
