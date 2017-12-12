//
//  LLModuleURLManager.m
//  Pods-LLModularizationDemo
//
//  Created by 李林 on 2017/12/8.
//

#import "LLModuleURLManager.h"
#import "LLModuleURLDefinition.h"

@interface LLModuleURLManager()

@end

@implementation LLModuleURLManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static LLModuleURLManager *sharedManager = nil;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[LLModuleURLManager alloc] init];
    });
    
    return sharedManager;
}

- (BOOL)openURL:(NSURL *)URL {
    return YES;
}

@end
