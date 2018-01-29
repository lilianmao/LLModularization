//
//  LabelModule.h
//  LLModularizationDemo
//
//  Created by 李林 on 1/4/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LabelModuleProtocol.h"

@interface LabelModule : NSObject <LabelModuleProtocol>

+ (instancetype)sharedModule;

@end
