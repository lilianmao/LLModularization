//
//  LLModuleURLDefinition.h
//  Pods-LLModularizationDemo
//
//  Created by 李林 on 2017/12/8.
//

#import <Foundation/Foundation.h>

@interface LLModuleURLDefinition : NSObject

@property (nonatomic, copy, readonly) NSString *scheme;

@property (nonatomic, copy, readonly) NSString *host;

@property (nonatomic, copy, readonly) NSString *port;

@property (nonatomic, copy, readonly) NSString *path;

@property (nonatomic, copy, readonly) NSString *params;

/**
 将传入的URL进行解析，获得一个URLDefinition对象。

 @param URL URL from outside
 @return self
 */
- (instancetype)initWithURL:(NSURL *)URL;

@end
