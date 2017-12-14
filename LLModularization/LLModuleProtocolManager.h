//
//  LLModuleProtocolManager.h
//  Pods-LLModularizationDemo
//
//  Created by 李林 on 2017/12/8.
//

#import <Foundation/Foundation.h>
#import "LLModuleProtocol.h"
#import "LLModuleConst.h"

@interface LLModuleProtocolManager : NSObject

+ (instancetype)sharedManager;

/**
 注册服务。包括Service以及实现该Service的Instance。
 */
- (BOOL)registerServiceWithServiceName:(NSString *)serviceName
                              instance:(NSString *)instanceName;


/**
 调用服务。
 */
- (BOOL)callServiceWithServiceName:(NSString *)serviceName
                    navigationMode:(LLModuleNavigationMode)mode
                      successBlock:(LLBasicSuccessBlock_t)success
                      failureBlock:(LLBasicFailureBlock_t)failure;

@end
