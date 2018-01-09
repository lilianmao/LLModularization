//
//  DataBaseModuleProtocol.h
//  LLModularizationDemo
//
//  Created by 李林 on 1/9/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LLModularization/LLModuleProtocol.h>

@protocol DataBaseModuleProtocol <LLModuleProtocol>

//TODO: 测试有些DataBase功能，看书《第7章》
/**
 URLPattern: ll://operateDB/:sql?tableName=table
 function: 操作数据库
 
 @param params params为附加参数
 */
+ (id)operateDataBaseWithParams:(NSDictionary *)params;

@end
