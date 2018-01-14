//
//  AppDelegate.m
//  LLModularizationDemo
//
//  Created by 李林 on 2017/12/7.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "AppDelegate.h"
#import "LLTabBarController.h"

#import <signal.h>
#import <execinfo.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[LLTabBarController alloc] init];
    [self.window makeKeyAndVisible];
    [self initHandler];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Crash Catch

- (void)initHandler {
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
    NSLog(@"exception = %@",exception);
    NSLog(@"callStackSymbols = %@",[exception callStackSymbols]);
    // TODO: report call chain
}

void signalHandler(int sig) {
    NSLog(@"signal = %d", sig);
}


@end
