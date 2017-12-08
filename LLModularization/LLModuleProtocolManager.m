//
//  LLModuleProtocolManager.m
//  Pods-LLModularizationDemo
//
//  Created by 李林 on 2017/12/8.
//

#import "LLModuleProtocolManager.h"
#import "LLModuleProtocol.h"

@interface LLModuleProtocolManager()

@property (nonatomic, copy) NSDictionary<NSString *, id<LLModuleProtocol>> *ProtocolConnector_Map;

@end

@implementation LLModuleProtocolManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static LLModuleProtocolManager *sharedManager = nil;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[LLModuleProtocolManager alloc] init];
    });
    
    return sharedManager;
}

- (void)registerProtocol:(NSString *)protocolStr andConnector:(id)connector {
    // 检查合法性，然后加入。
}

@end
