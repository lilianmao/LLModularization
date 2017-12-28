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

// TODO: 为每个module加上module的依赖(需求)服务，由中心化的解决方案来check一下。

@end
