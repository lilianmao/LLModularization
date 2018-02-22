//
//  ProfileModule.m
//  LLModularizationDemo
//
//  Created by 李林 on 1/25/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "ProfileModule.h"
#import "ProfileModuleMainViewController.h"

#import <LLModularization/LLModule.h>

@interface ProfileModule()

@end

@implementation ProfileModule

#pragma mark - sharedConnector

+ (instancetype)sharedModule {
    static dispatch_once_t onceToken;
    static ProfileModule *sharedModule = nil;
    
    dispatch_once(&onceToken, ^{
        sharedModule = [[ProfileModule alloc] init];
    });
    
    return sharedModule;
}

#pragma mark - register

+ (void)load {
    [[LLModule sharedInstance] registerServiceWithServiceName:NSStringFromSelector(@selector(showProfileModule)) URLPattern:@"ll://profile/show" instance:NSStringFromClass(self)];
    [[LLModule sharedInstance] registerRelyService:nil];
}


#pragma mark - LLModuleProtocol

- (void)initModule {
    NSLog(@"init Profile Module.");
}

- (void)destroyModule {
    NSLog(@"destroy Profile Module.");
}

- (void)callServiceWithURL:(NSString *)url
                parameters:(NSDictionary *)params
            navigationMode:(LLModuleNavigationMode)mode
              successBlock:(LLBasicSuccessBlock_t)success
              failureBlock:(LLBasicFailureBlock_t)failure {
    
}

#pragma mark - ProfileModule

+ (UIViewController *)showProfileModule {
    ProfileModuleMainViewController *profileMainVC = [[ProfileModuleMainViewController alloc] init];
    return profileMainVC;
}

@end
