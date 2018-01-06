//
//  DataStoreModule.m
//  LLModularizationDemo
//
//  Created by 李林 on 1/5/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "DataStoreModule.h"
#import <LLModularization/LLModule.h>

@interface DataStoreModule()

@end

@implementation DataStoreModule

#pragma mark - sharedConnector

+ (instancetype)sharedModule {
    static dispatch_once_t onceToken;
    static DataStoreModule *sharedModule = nil;
    
    dispatch_once(&onceToken, ^{
        sharedModule = [[DataStoreModule alloc] init];
    });
    
    return sharedModule;
}

#pragma mark - register

+ (void)load {
    [[LLModule sharedInstance] registerServiceWithServiceName:NSStringFromSelector(@selector(storeData:inPath:)) URLPattern:@"ll://storeData" instance:NSStringFromClass(self)];
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

- (BOOL)storeData:(id)data inPath:(NSString *)path {
    return YES;
}

@end
