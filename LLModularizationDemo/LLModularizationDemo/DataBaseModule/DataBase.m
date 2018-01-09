//
//  DataBase.m
//  modularizationDemo
//
//  Created by 李林 on 1/9/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "DataBase.h"
#import <FMDB/FMDB.h>

static DataBase *_DBCtrl = nil;

@interface DataBase() <NSCopying, NSMutableCopying> {
    FMDatabase *_db;
}

@end

@implementation DataBase

+ (instancetype)sharedDataBase {
    
    if (_DBCtrl == nil) {
        _DBCtrl = [[DataBase alloc] init];
        [_DBCtrl initDataBase];
    }
    
    return _DBCtrl;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    if (_DBCtrl == nil) {
        _DBCtrl = [super allocWithZone:zone];
    }
    
    return _DBCtrl;
}

- (id)copy {
    return self;
}

- (id)mutableCopy {
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return self;
}


- (void)initDataBase {
    // 获得Documents目录路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    // 文件路径
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"model.sqlite"];
    
    // 实例化FMDataBase对象
    _db = [FMDatabase databaseWithPath:filePath];
    
    [_db open];
    
    // 初始化数据表
    NSString *personSql = @"CREATE TABLE 'person' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'person_id' VARCHAR(255),'person_name' VARCHAR(255),'person_age' VARCHAR(255),'person_number'VARCHAR(255)) ";
    NSString *carSql = @"CREATE TABLE 'car' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'own_id' VARCHAR(255),'car_id' VARCHAR(255),'car_brand' VARCHAR(255),'car_price'VARCHAR(255)) ";
    
    [_db executeUpdate:personSql];
    [_db executeUpdate:carSql];

    [_db close];
}

#pragma mark - API

- (void)executeSQL:(NSString *)sql {
    
}

@end
