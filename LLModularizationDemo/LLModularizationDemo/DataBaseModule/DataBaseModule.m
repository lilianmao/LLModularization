//
//  DataBaseModule.m
//  LLModularizationDemo
//
//  Created by 李林 on 1/9/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "DataBaseModule.h"
#import <LLModularization/LLModule.h>
#import "DataBase.h"

@interface DataBaseModule()

@end

@implementation DataBaseModule

#pragma mark - sharedConnector

+ (instancetype)sharedModule {
    static dispatch_once_t onceToken;
    static DataBaseModule *sharedModule = nil;
    
    dispatch_once(&onceToken, ^{
        sharedModule = [[DataBaseModule alloc] init];
    });
    
    return sharedModule;
}

#pragma mark - register

+ (void)load {
    [[LLModule sharedInstance] registerServiceWithServiceName:NSStringFromSelector(@selector(operateDataBaseWithParams:)) URLPattern:@"ll://operateDB/:sql/:tableName" instance:NSStringFromClass(self)];
    [[LLModule sharedInstance] registerServiceWithServiceName:NSStringFromSelector(@selector(operateDataBaseWithParams:)) URLPattern:@"ll://operateDB/:sql" instance:NSStringFromClass(self)];
}

#pragma mark - LLModuleProtocol

- (void)initModule {
    NSLog(@"init Data Store Module.");
}

- (void)destroyModule {
    NSLog(@"destroy Data Store Module.");
}

- (void)callServiceWithURL:(NSString *)url
                parameters:(NSDictionary *)params
            navigationMode:(LLModuleNavigationMode)mode
              successBlock:(LLBasicSuccessBlock_t)success
              failureBlock:(LLBasicFailureBlock_t)failure {
    if ([LLUtils isNilOrEmtpyForString:url]) {
        failure(nil);
    }
    
    [[LLModule sharedInstance] callServiceWithCallerConnector:NSStringFromClass([self class]) URL:url parameters:params navigationMode:mode successBlock:success failureBlock:failure];
}

+ (NSArray *)relyService {
    return @[];
}

#pragma mark - DataStoreModuleProtocol

+ (id)operateDataBaseWithParams:(NSDictionary *)params {
    NSString *sql = params[@"sql"];
    NSString *tableName = params[@"tableName"];
    
    NSRange range = [sql rangeOfString:@"select" options:NSCaseInsensitiveSearch];
    if (range.length > 0) {
        return [[DataBase sharedDataBase] executeQuerySQL:sql tableName:tableName];
    } else {
        [[DataBase sharedDataBase] executeUpdateSQL:sql];
    }
    
    return nil;
}

@end
