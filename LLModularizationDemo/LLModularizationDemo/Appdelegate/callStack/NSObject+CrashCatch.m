//
//  NSObject+CrashCatch.m
//  LLModularizationDemo
//
//  Created by 李林 on 1/15/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "NSObject+CrashCatch.h"
#import "callStackManager.h"

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
    [callStackManager sendCallStack];
    NSLog(@"exception = %@", exception);
    NSLog(@"callStackSymbols = %@", [exception callStackSymbols]);
}

void signalHandler(int sig) {
    NSLog(@"signal = %d", sig);
}

@end
