//
//  MeModuleConnector.h
//  LLModularizationDemo
//
//  Created by 李林 on 2017/12/9.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeModuleProtocol.h"

#import <LLModularization/LLModule.h>

@interface MeModuleConnector : NSObject <MeModuleProtocol>

+ (instancetype)sharedConnector;

@end
