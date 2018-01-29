//
//  LabelModuleCollectionView.h
//  LLModularizationDemo
//
//  Created by 李林 on 1/5/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LabelModuleLabelNode;
@class LabelModuleLabelCategory;

@protocol LabelModuleCollectionViewDelegate <NSObject>

- (void)getSelectedInterestLabelsCount:(NSInteger)count;

@end

@interface LabelModuleCollectionView : UIView

@property (nonatomic, weak) id<LabelModuleCollectionViewDelegate> delegate;

- (void)setCollectionViewCategories:(NSArray<LabelModuleLabelCategory *> *)categories;

- (NSArray<LabelModuleLabelNode *> *)getSelectedLabels;

@end
