//
//  MeModuleMainViewController.h
//  LLModularizationDemo
//
//  Created by 李林 on 12/26/17.
//  Copyright © 2017 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeModuleMainModel : NSObject

@property (nonatomic, copy) NSString *imgName;
@property (nonatomic, copy) NSString *title;

- (instancetype)initWithImgName:(NSString *)imgName title:(NSString *)title;

@end

@interface MeModuleMainViewController : UIViewController

- (NSString *)getAccountDataWithParams:(NSDictionary *)params;

@end
