//
//  callStackManager.h
//  LLModularizationDemo
//
//  Created by 李林 on 1/22/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "callStackSubmitModel.h"

@interface callStackManager : NSObject

/**
 存本次调用栈
 
 @param submitType 提交的类型（crash/sampling）
 */
+ (void)saveCallStackWithType:(callStackSubmitType)submitType;

/**
 向服务端发送调用栈（包含本地APP启动以来的调用栈）
 */
+ (void)sendCallStack;

/**
 向服务端发送调用栈（当启动时，上一次APP可能因为crash存入数据库一些数据，第二次启动发送）
 */
+ (void)sendIfNeedWhenLanuch;

@end
