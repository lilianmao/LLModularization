//
//  LabelModuleNodeCell.h
//  LLModularizationDemo
//
//  Created by 李林 on 1/5/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabelModuleLabelNode.h"

@interface LabelModuleNodeCellModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) LabelModuleNodeState state;
@property (nonatomic, strong) LabelModuleLabelNode *label;

+ (instancetype)cellModelWith:(LabelModuleLabelNode *)label;

@end

@interface LabelModuleNodeCell : UICollectionViewCell

@property (nonatomic, strong) LabelModuleNodeCellModel *cellModel;

@property (nonatomic, assign) BOOL state;

@end
