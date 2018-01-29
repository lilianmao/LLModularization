//
//  DataBase.h
//  modularizationDemo
//
//  Created by 李林 on 1/9/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabase;

@interface DataBase : NSObject

@property (nonatomic, strong, readonly) FMDatabase *db;

+ (instancetype)sharedDataBase;

- (BOOL)executeUpdateSQL:(NSString *)sql
               tableName:(NSString *)tableName
               objectStr:(NSString *)objStr;

- (NSArray *)executeQuerySQL:(NSString *)sql
                   tableName:(NSString *)tableName;

@end
