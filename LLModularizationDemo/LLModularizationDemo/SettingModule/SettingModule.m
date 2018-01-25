//
//  SettingModule.m
//  LLModularizationDemo
//
//  Created by 李林 on 1/25/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "SettingModule.h"
#import "SettingModuleMainViewController.h"

#import <LLModularization/LLModule.h>

@interface SettingModule()

@end

@implementation SettingModule

#pragma mark - sharedConnector

+ (instancetype)sharedModule {
    static dispatch_once_t onceToken;
    static SettingModule *sharedModule = nil;
    
    dispatch_once(&onceToken, ^{
        sharedModule = [[SettingModule alloc] init];
    });
    
    return sharedModule;
}

#pragma mark - register

+ (void)load {
    [[LLModule sharedInstance] registerServiceWithServiceName:NSStringFromSelector(@selector(showSettingModule)) URLPattern:@"ll://setting.show" instance:NSStringFromClass(self)];
    [[LLModule sharedInstance] registerRelyService:nil];
}


#pragma mark - LLModuleProtocol

- (void)initModule {
    NSLog(@"init Setting Module.");
}

- (void)destroyModule {
    NSLog(@"destroy Setting Module.");
}

- (void)callServiceWithURL:(NSString *)url
                parameters:(NSDictionary *)params
            navigationMode:(LLModuleNavigationMode)mode
              successBlock:(LLBasicSuccessBlock_t)success
              failureBlock:(LLBasicFailureBlock_t)failure {
    
}

#pragma mark - ProfileModule

+ (UIViewController *)showSettingModule {
    SettingModuleMainViewController *settingMainVC = [[SettingModuleMainViewController alloc] init];
    NSLog(@"%@", settingMainVC);
    return settingMainVC;
}

@end
