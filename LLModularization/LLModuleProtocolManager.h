//
//  LLModuleProtocolManager.h
//  Pods-LLModularizationDemo
//
//  Created by 李林 on 2017/12/8.
//

#import <Foundation/Foundation.h>

@interface LLModuleProtocolManager : NSObject

+ (instancetype)sharedManager;

- (void)registerProtocol:(NSString *)protocolStr andConnector:(id<LLModuleProtocol>)connector;

@end
