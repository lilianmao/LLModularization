//
//  LLModuleNavigator.h
//  AFNetworking
//
//  Created by 李林 on 12/12/17.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LLModuleNavigationMode) {
    LLModuleNavigationModeNone = 0,
    LLModuleNavigationModePush = 1,
    LLModuleNavigationModePresent = 2
};

@interface LLModuleNavigator : NSObject

/**
 显示传入的VC
 
 @param controller 传入的VC
 @param mode 显示模式（默认Push）
 @return 返回一个数组（Push/Pop新VC的VC，将presenting的VC也存放起来，用作链路使用）
 */
+ (NSArray<UIViewController *> *)showController:(UIViewController *)controller
                             withNavigationMode:(LLModuleNavigationMode)mode;

@end
