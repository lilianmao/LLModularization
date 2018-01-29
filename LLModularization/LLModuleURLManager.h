//
//  LLModuleURLManager.h
//  Pods-LLModularizationDemo
//
//  Created by 李林 on 2017/12/8.
//

#import <Foundation/Foundation.h>
#import "LLModuleProtocol.h"
#import "LLModuleNavigator.h"
#import "LLModuleConst.h"

@interface LLModuleURLManager : NSObject

+ (instancetype)sharedManager;

/**
 注册服务。包括URL模式、Service以及实现该Service的Instance。
 */
- (BOOL)registerServiceWithServiceName:(NSString *)serviceName
                            URLPattern:(NSString *)urlPattern
                              instance:(NSString *)instanceName;


/**
 调用服务。
 */
- (void)callServiceWithCallerConnector:(NSString *)connector
                                   URL:(NSString *)url
                            parameters:(NSDictionary *)params
                        navigationMode:(LLModuleNavigationMode)mode
                          successBlock:(LLBasicSuccessBlock_t)success
                          failureBlock:(LLBasicFailureBlock_t)failure;

/**
 注册module依赖的服务
 */
- (void)registerRelyService:(NSString *)serviceName;

/**
 每个模块所需要(依赖)的服务，由LLModularization来check，如果没有相关服务注册，则报错无法打开。
 */
- (NSArray *)checkRelyService;

@end
