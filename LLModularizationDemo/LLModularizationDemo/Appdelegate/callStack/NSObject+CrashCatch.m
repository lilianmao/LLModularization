//
//  NSObject+CrashCatch.m
//  LLModularizationDemo
//
//  Created by 李林 on 1/15/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "NSObject+CrashCatch.h"
#import "callStackManager.h"

#import <objc/runtime.h>
#import <signal.h>
#import <execinfo.h>

@implementation NSObject (CrashCatch)

#pragma mark - Crash Catch

+ (void)initCrashCatchHandler {
    struct sigaction newSignalAction;
    memset(&newSignalAction, 0,sizeof(newSignalAction));
    newSignalAction.sa_handler = &signalHandler;
    sigaction(SIGABRT, &newSignalAction, NULL);
    sigaction(SIGILL, &newSignalAction, NULL);
    sigaction(SIGSEGV, &newSignalAction, NULL);
    sigaction(SIGFPE, &newSignalAction, NULL);
    sigaction(SIGBUS, &newSignalAction, NULL);
    sigaction(SIGPIPE, &newSignalAction, NULL);
    
    //异常时调用的函数
    NSSetUncaughtExceptionHandler(&handleExceptions);
}

void handleExceptions(NSException *exception) {
    [callStackManager saveCallStackWithType:callStackSubmitTypeCrash];
    // 此时不发，因为发请求是一个耗时的操作，需要资源很多；而系统处理crash会回收资源，处理时间很短，故等到下次启动APP的时候发送。
    NSLog(@"exception = %@", exception);
    NSLog(@"callStackSymbols = %@", [exception callStackSymbols]);
}

void signalHandler(int sig) {
    NSLog(@"signal = %d", sig);
}

@end
