//
//  LLModuleCallStackManager.h
//  LLModularization
//
//  Created by 李林 on 12/19/17.
//

#import <Foundation/Foundation.h>
#import "LLModuleProtocol.h"

typedef NS_ENUM(NSInteger, LLModuleServiceType) {
    LLModuleServiceTypeNone = 0,
    LLModuleServiceTypePush = 1,        // Push
    LLModuleServiceTypePresent = 2,     // Present
    LLModuleServiceTypePop = 3,         // Pop
    LLModuleServiceTypeDismiss = 4,     // Dismiss
    LLModuleServiceTypeBackground = 5,  // 后台，一般是非页面跳转，请求数据服务。
};

/**
 栈信息封装
 */
@interface LLModuleCallStackItem : NSObject

@property (nonatomic, copy) NSArray *moduleCallChain;
@property (nonatomic, copy) NSString *service;
@property (nonatomic, assign) LLModuleServiceType serviceType;

- (instancetype)initWithModuleCallChain:(NSArray *)callChain
                             andService:(NSString *)service
                         andServiceType:(LLModuleServiceType)serviceType;

@end

@interface LLModuleCallStackManager : NSObject

+ (NSArray *)getModuleCallStack;

+ (void)appendCallStackItemWithCallerModule:(NSString *)callerModule
                           callerController:(NSString *)callerController
                               calleeModule:(NSString *)calleeModule
                           calleeController:(NSString *)calleeController
                              moduleService:(NSString *)service
                                serviceType:(LLModuleServiceType)type;

+ (void)popWithControllers:(NSArray<NSString *> *)controllers
               serviceName:(NSString *)serviceName
                   popType:(LLModuleServiceType)type;

+ (void)popToController:(NSString *)controller
            serviceName:(NSString *)serviceName
                popType:(LLModuleServiceType)type;

@end

