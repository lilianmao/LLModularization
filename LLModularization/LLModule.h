//
//  LLModule.h
//  Pods-LLModularizationDemo
//
//  Created by 李林 on 2017/12/8.
//

#import <Foundation/Foundation.h>
#import "LLModuleProtocol.h"
#import "LLModuleNavigator.h"
#import "LLModuleConst.h"

@interface LLModule : NSObject

+ (instancetype)sharedInstance;

/**
 注册服务。包括URL模式、Service以及实现该Service的Instance。

 @return 成功与否
 */
- (BOOL)registerServiceWithServiceName:(NSString *)serviceName
                            URLPattern:(NSString *)urlPattern
                              instance:(NSString *)instanceName;


/**
 调用服务。

 @param connector 传入自身module的Connector，这里需要进行链路记录。
 */
- (void)callServiceWithCallConnector:(id<LLModuleProtocol>)connector
                                 URL:(NSString *)url
                          parameters:(NSDictionary *)params
                      navigationMode:(LLModuleNavigationMode)mode
                        successBlock:(LLBasicSuccessBlock_t)success
                        failureBlock:(LLBasicFailureBlock_t)failure;

@end
