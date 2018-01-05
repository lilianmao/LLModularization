//
//  DataStoreModule.h
//  LLModularizationDemo
//
//  Created by 李林 on 1/5/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataStoreModuleProtocol.h"

@interface DataStoreModule : NSObject <DataStoreModuleProtocol>

+ (instancetype)sharedModule;

@end
