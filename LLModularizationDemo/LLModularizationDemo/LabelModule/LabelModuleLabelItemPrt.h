//
//  LabelModuleLabelItemPrt.h
//  LLModularizationDemo
//
//  Created by 李林 on 1/6/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

// TODO: Review协议化对象如何运作的

typedef NS_ENUM(NSInteger, LabelModuleNodeState) {
    LabelModuleNodeStateSelected,
    LabelModuleNodeStateDeSelect
};

@protocol LabelModuleLabelItemPrt <NSObject>

@required
@property (nonatomic, assign) int labelId;
@property (nonatomic, assign) BOOL state;
@property (nonatomic, copy) NSString *__nonnull name;

-(nonnull NSString *)description;

@optional
- (nonnull instancetype)initLabelNodeWithLabelId:(int)labelId
                                           state:(BOOL)state
                                            name:(nonnull NSString *)name;

@end
