//
//  LoginModule.h
//  LLModularizationDemo
//
//  Created by 李林 on 1/4/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginModuleProtocol.h"

@interface LoginModule : NSObject <LoginModuleProtocol>

+ (instancetype)sharedModule;

@end
