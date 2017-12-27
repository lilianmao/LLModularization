//
//  LLModuleCallStackManager.h
//  LLModularization
//
//  Created by 李林 on 12/19/17.
//

#import <Foundation/Foundation.h>
#import "LLModuleProtocol.h"

typedef NS_ENUM(NSInteger, LLModuleTreeServiceType) {
    LLModuleTreeServiceTypeNone = 0,
    LLModuleTreeServiceTypePush = 1,        // Push
    LLModuleTreeServiceTypePresent = 2,     // Present
    LLModuleTreeServiceTypePop = 3,         // Pop
    LLModuleTreeServiceTypeDismiss = 4,     // Dismiss
    LLModuleTreeServiceTypeBackground = 5,  // 后台，一般是非页面跳转，请求数据服务。
};

/**
 栈信息封装
 */
@interface LLModuleCallStackItem : NSObject

@property (nonatomic, copy) NSArray *moduleCallChain;
@property (nonatomic, copy) NSString *service;
@property (nonatomic, assign) LLModuleTreeServiceType serviceType;

- (instancetype)initWithModuleCallChain:(NSArray *)callChain
                             andService:(NSString *)service
                         andServiceType:(LLModuleTreeServiceType)serviceType;

@end

@interface LLModuleCallStackManager : NSObject

+ (NSArray *)getModuleCallStack;

+ (void)appendCallStackItemWithCallerModule:(NSString *)callerModule
                           callerController:(NSString *)callerController
                               calleeModule:(NSString *)calleeModule
                           calleeController:(NSString *)calleeController
                              moduleService:(NSString *)service
                                serviceType:(LLModuleTreeServiceType)type;

+ (void)popWithControllers:(NSArray<NSString *> *)controllers
               serviceName:(NSString *)serviceName
                   popType:(LLModuleTreeServiceType)type;

+ (void)popToController:(NSString *)controller
            serviceName:(NSString *)serviceName
                popType:(LLModuleTreeServiceType)type;

@end

