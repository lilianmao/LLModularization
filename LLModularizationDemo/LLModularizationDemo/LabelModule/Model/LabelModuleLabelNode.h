//
//  LabelModuleLabelNode.h
//  LLModularizationDemo
//
//  Created by 李林 on 1/5/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LabelModuleNodeState) {
    LabelModuleNodeStateSelected,
    LabelModuleNodeStateDeSelect
};

@interface LabelModuleLabelNode : NSObject <NSCopying>

@property (nonatomic, assign) int64_t labelId;
@property (nonatomic, assign) BOOL state;
@property (nonatomic, copy) NSString *name;

- (instancetype)initLabelNodeWithLabelId:(int64_t)labelId
                                   state:(BOOL)state
                                    name:(NSString *)name;

@end
