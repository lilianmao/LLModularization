//
//  LabelModuleNodeHeader.h
//  LLModularizationDemo
//
//  Created by 李林 on 1/5/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LabelModuleHeaderType) {
    LabelModuleHeaderTypeNormal,
    LabelModuleHeaderTypeNoLine
};

@interface LabelModuleNodeHeader : UICollectionReusableView

@property (nonatomic, assign) LabelModuleHeaderType type;

- (void)setImageName:(NSString *)imgName andTitle:(NSString *)title;

@end
