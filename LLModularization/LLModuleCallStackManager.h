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
    LLModuleTreeServiceTypeForeground = 1,      // 前台，一般是页面跳转。
    LLModuleTreeServiceTypeBackground = 2       // 后台，一般是非页面跳转，请求数据服务。
};

typedef NS_ENUM(NSInteger, LLModuleTreePopType) {
    LLModuleTreePopTypeNone = 0,
    LLModuleTreePopTypePop = 1,
    LLModuleTreePopTypeDismiss = 2
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

+ (void)appendCallStackItemWithCallerConnector:(NSString *)callerConnector
                               calleeConnector:(NSString *)calleeConnector
                                 moduleService:(NSString *)service
                                   serviceType:(LLModuleTreeServiceType)type;

+ (void)popToPage:(NSString *)page withPopType:(LLModuleTreePopType)type;

+ (void)popWithPage:(NSString *)page withPopType:(LLModuleTreePopType)type;

@end

