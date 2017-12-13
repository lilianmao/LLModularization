//
//  LLModuleProtocolManager.h
//  Pods-LLModularizationDemo
//
//  Created by 李林 on 2017/12/8.
//

#import <Foundation/Foundation.h>
#import "LLModuleProtocol.h"

@interface LLModuleProtocolManager : NSObject

+ (instancetype)sharedManager;

- (BOOL)registerProtocol:(Protocol *)protocol
            andConnector:(Class)connector;

- (BOOL)openModuleWithCallConnector:(id<LLModuleProtocol>)connector
                           protocol:(Protocol *)protocol
                           selector:(SEL)sel
                             params:(NSDictionary *)params
                     navigationMode:(LLModuleNavigationMode)mode
                    withReturnBlock:(returnBlock)block;

@end
