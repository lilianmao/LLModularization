//
//  LLModuleProtocol.h
//  Pods-LLModularizationDemo
//
//  Created by 李林 on 2017/12/8.
//

#import <Foundation/Foundation.h>
#import "LLModuleNavigator.h"

typedef void(^returnBlock)(id obj, id returnValue);

@class UIViewController;
@class LLModuleURLDefinition;

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

/**
 这是操作另一个Module的必要的四件套
 
 @param protocol 协议用来找到VC
 @param sel VC的方法
 @param params 方法的参数
 @param mode 如果是打开，则需要打开VC的方式
 @return 调用该Module成功与否
 */
- (BOOL)openModuleWithProtocol:(Protocol *)protocol
                      selector:(SEL)sel
                        params:(NSDictionary *)params
                navigationMode:(LLModuleNavigationMode)mode
               withReturnBlock:(returnBlock)block;

@optional

- (BOOL)canOpenURL:(LLModuleURLDefinition *)URLDefinition;

- (UIViewController *)handle:(LLModuleURLDefinition *)URLDefinition;

@end
