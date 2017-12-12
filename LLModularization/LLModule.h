//
//  LLModule.h
//  Pods-LLModularizationDemo
//
//  Created by 李林 on 2017/12/8.
//

#import <Foundation/Foundation.h>
#import "LLModuleProtocol.h"

@interface LLModule : NSObject

+ (instancetype)sharedInstance;

- (BOOL)registerProtocol:(Protocol *)protocol
            andConnector:(Class)connector;

- (BOOL)openURL:(NSURL *)URL;

@end
