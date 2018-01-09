//
//  DataBaseModule.h
//  LLModularizationDemo
//
//  Created by 李林 on 1/9/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBaseModuleProtocol.h"

@interface DataBaseModule : NSObject <DataBaseModuleProtocol>

+ (instancetype)sharedModule;

@end
