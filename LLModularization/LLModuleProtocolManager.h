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

@end
