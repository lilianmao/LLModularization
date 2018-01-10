//
//  DataBase.m
//  modularizationDemo
//
//  Created by 李林 on 1/9/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "DataBase.h"
#import <FMDB/FMDB.h>
#import <objc/runtime.h>

#import "DataBase+LabelModuleLabelNode.h"

static DataBase *_DBCtrl = nil;

@interface DataBase() <NSCopying, NSMutableCopying>

@property (nonatomic, strong) FMDatabase *db;

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
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"modularizationDemo.db"];
    
    // 实例化FMDataBase对象
    _db = [FMDatabase databaseWithPath:filePath];
}

#pragma mark - API

- (BOOL)executeUpdateSQL:(NSString *)sql {
    [_db open];

    // TODO: 分给各个分类执行，需要传入参数objStr
    BOOL result = [_db executeUpdate:sql];
    NSLog(@"%d", result);
    
    [_db close];
    
    return result;
}

// TODO: 设计合理性有待考证，可以使用runtime的执行方法。
- (NSArray *)executeQuerySQL:(NSString *)sql
                   tableName:(NSString *)tableName {
    if ([tableName isEqualToString:NSStringFromClass([LabelModuleLabelNode class])]) {
        return [self LabelModuleLabelNode_getAllElementsWithSQL:sql];
    }
    
    return nil;
}

@end
