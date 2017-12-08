//
//  LLModule.m
//  Pods-LLModularizationDemo
//
//  Created by 李林 on 2017/12/8.
//

#import "LLModule.h"
#import "LLModuleProtocolManager.h"
#import "LLModuleURLManager.h"
#import "LLModuleUtils.h"

@interface LLModule()

@end

@implementation LLModule

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LLModule *sharedInstance = nil;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LLModule alloc] init];
    });
    
    return sharedInstance;
}

- (void)registerProtocol:(NSString *)protocolStr andConnector:(id<LLModuleProtocol>)connector {
    // 判断语句思考，重写，utils文件不可以用分类的形式
    [[LLModuleProtocolManager sharedManager] registerProtocol:protocolStr andConnector:connector];
}

- (void)openURL:(NSURL *)URL {
    if (URL != nil) {
        [[LLModuleURLManager sharedManager] openURL:URL];
    }
}

@end
