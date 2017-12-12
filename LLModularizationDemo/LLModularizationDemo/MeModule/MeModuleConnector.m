//
//  MeModuleConnector.m
//  LLModularizationDemo
//
//  Created by 李林 on 2017/12/9.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "MeModuleConnector.h"
#import "MeModuleProtocol.h"
#import <LLModularization/LLModule.h>

@interface MeModuleConnector() <MeModuleProtocol>

@end

@implementation MeModuleConnector

+ (void)load {
    [[LLModule sharedInstance] registerProtocol:@protocol(MeModuleProtocol) andConnector:[MeModuleConnector class]];
}

#pragma mark - LLModuleProtocol

- (void)initModule {
    NSLog(@"init MeModule");
}

- (void)destroyModule {
    NSLog(@"destroy MeModule");
}

#pragma mark - MeModuleProtocol

- (void)initMeModuleWithName:(NSString *)name
                      andAge:(NSInteger)age {
    
}

@end
