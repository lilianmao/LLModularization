//
//  LLModuleURLManager.h
//  Pods-LLModularizationDemo
//
//  Created by 李林 on 2017/12/8.
//

#import <Foundation/Foundation.h>

@class LLModuleURLDefinition;
@interface LLModuleURLManager : NSObject

+ (instancetype)sharedManager;

- (BOOL)openURL:(NSURL *)URL;

@end
