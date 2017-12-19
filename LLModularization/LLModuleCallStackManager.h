//
//  LLModuleCallStackManager.h
//  LLModularization
//
//  Created by 李林 on 12/19/17.
//

#import <Foundation/Foundation.h>
#import "LLModuleProtocol.h"

@interface LLModuleCallStackItem : NSObject

- (instancetype)initWithModuleConnector:(id<LLModuleProtocol>)connector
                            moduleClass:(NSString *)moduleClass
                           moduleMethod:(NSString *)moduleMethod;

@end

@interface LLModuleCallStackManager : NSObject

+ (NSArray *)getModuleCallStack;

+ (void)appendCallStackItemWithCallConnector:(id<LLModuleProtocol>)connector
                                 moduleClass:(NSString *)moduleClass
                                moduleMethod:(NSString *)moduleMethod;


@end

