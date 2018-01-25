//
//  ProfileModule.h
//  LLModularizationDemo
//
//  Created by 李林 on 1/25/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProfileModuleProtocol.h"

@interface ProfileModule : NSObject <ProfileModuleProtocol>

+ (instancetype)sharedModule;

@end
