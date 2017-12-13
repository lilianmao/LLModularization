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

@end
