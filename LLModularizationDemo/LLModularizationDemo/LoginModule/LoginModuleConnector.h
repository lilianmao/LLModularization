//
//  LoginModuleConnector.h
//  LLModularizationDemo
//
//  Created by 李林 on 2017/12/8.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginModuleProtocol.h"

#import <LLModularization/LLModule.h>

@interface LoginModuleConnector : NSObject <LoginModuleProtocol>

+ (instancetype)sharedConnector;

@end
