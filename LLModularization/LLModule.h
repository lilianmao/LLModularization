//
//  LLModule.h
//  Pods-LLModularizationDemo
//
//  Created by 李林 on 2017/12/8.
//

#import <Foundation/Foundation.h>
#import "LLModuleProtocol.h"
#import "LLModuleNavigator.h"

@interface LLModule : NSObject

+ (instancetype)sharedInstance;

- (BOOL)registerProtocol:(Protocol *)protocol
            andConnector:(Class)connector;


/**
 调用方操作被调用方的函数

 @param connector 传入自身module的Connector，这里需要进行链路记录。
 @return 操作成功与否
 */
- (BOOL)openModuleWithCallConnector:(id<LLModuleProtocol>)connector
                           protocol:(Protocol *)protocol
                           selector:(SEL)sel
                             params:(NSDictionary *)params
                     navigationMode:(LLModuleNavigationMode)mode
                    withReturnBlock:(returnBlock)block;

- (BOOL)openURL:(NSURL *)URL;

@end
