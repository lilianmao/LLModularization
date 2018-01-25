//
//  SettingModuleMainViewCell.h
//  LLModularizationDemo
//
//  Created by 李林 on 1/25/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingModuleMainViewCell : UITableViewCell

- (void)setCellText:(NSString *)str
          switchVal:(BOOL)isOn
     lineViewHidden:(BOOL)hidden;

@end
