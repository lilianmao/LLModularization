//
//  LLModuleProtocol.h
//  Pods-LLModularizationDemo
//
//  Created by 李林 on 2017/12/8.
//

#import <Foundation/Foundation.h>

@class UIViewController;
@class LLModuleURLDefinition;
@protocol LLModuleProtocol <NSObject>

@required

- (void)initModule;

- (void)destroyModule;

@optional

- (BOOL)canOpenURL:(LLModuleURLDefinition *)URLDefinition;

- (UIViewController *)handle:(LLModuleURLDefinition *)URLDefinition;

@end
