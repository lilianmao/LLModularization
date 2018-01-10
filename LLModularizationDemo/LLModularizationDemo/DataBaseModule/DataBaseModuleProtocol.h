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

// TODO: 这里;解析不出来，需要修改routes的算法。
/**
 URLPattern: ll://operateDB/:sql/:tableName
 function: 操作数据库
 
 @param params params为附加参数
 */
+ (id)operateDataBaseWithParams:(NSDictionary *)params;

@end
