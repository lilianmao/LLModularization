//
//  MeModuleProtocol.h
//  LLModularizationDemo
//
//  Created by 李林 on 2017/12/9.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LLModularization/LLModuleProtocol.h>

@protocol MeModuleProtocol <LLModuleProtocol>

@required

- (void)initMeModuleWithName:(NSString *)name
                      andAge:(NSInteger)age;

@end
