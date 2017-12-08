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

- (void)registerProtocol:(NSString *)protocolStr andConnector:(id<LLModuleProtocol>)connector;

- (void)openURL:(NSURL *)URL;

@end
