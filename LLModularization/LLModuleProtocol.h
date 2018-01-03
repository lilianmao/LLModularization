//
//  LLModuleProtocol.h
//  Pods-LLModularizationDemo
//
//  Created by 李林 on 2017/12/8.
//

#import <Foundation/Foundation.h>
#import "LLModuleNavigator.h"
#import "LLModuleConst.h"

@class UIViewController;

@protocol LLModuleProtocol <NSObject>

@required

/**
 初始化Module的公共工作
 */
- (void)initModule;

/**
 销毁Module的公共工作
 */
- (void)destroyModule;

- (void)callServiceWithURL:(NSString *)url
                parameters:(NSDictionary *)params
            navigationMode:(LLModuleNavigationMode)mode
              successBlock:(LLBasicSuccessBlock_t)success
              failureBlock:(LLBasicFailureBlock_t)failure;

/**
 每个模块所需要(依赖)的服务，由LLModularization来check，如果没有相关服务注册，则报错无法打开。

 @return 该模块依赖的服务
 */
+ (NSArray *)relyService;

@end
