//
//  DataBaseModuleProtocol.h
//  LLModularizationDemo
//
//  Created by 李林 on 1/9/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LLModularization/LLModuleProtocol.h>

/*
 这个Module所需要的参数(sql:required, objStr和tableName:optional)
 */
static NSString *const DataBaseModule_SQL = @"sql";
static NSString *const DataBaseModule_ObjStr = @"objStr";
static NSString *const DataBaseModule_TableName = @"tableName";


@protocol DataBaseModuleProtocol <LLModuleProtocol>

/**
 URLPattern: ll://operateDB
 function: 操作数据库
 
 注：SQL只能作为参数，如果放在URL中，存在问号，会被URL解析成参数。另外两个objStr和tableName是可选参数。
 @param params params为DataBaseModule_SQL、DataBaseModule_ObjStr和DataBaseModule_TableName参数
 */
+ (id)operateDataBaseWithParams:(NSDictionary *)params;

@end
