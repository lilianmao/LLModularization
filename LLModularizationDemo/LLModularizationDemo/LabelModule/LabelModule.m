//
//  LabelModule.m
//  LLModularizationDemo
//
//  Created by 李林 on 1/4/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "LabelModule.h"
#import <LLModularization/LLModule.h>
#import "LabelModuleMainViewController.h"
#import "LabelModuleLabelManager.h"

@interface LabelModule()

@end

@implementation LabelModule

#pragma mark - sharedConnector

+ (instancetype)sharedModule {
    static dispatch_once_t onceToken;
    static LabelModule *sharedModule = nil;
    
    dispatch_once(&onceToken, ^{
        sharedModule = [[LabelModule alloc] init];
    });
    
    return sharedModule;
}

#pragma mark - register

+ (void)load {
    [[LLModule sharedInstance] registerServiceWithServiceName:NSStringFromSelector(@selector(showLabelModule)) URLPattern:@"ll://label.show" instance:NSStringFromClass(self)];
    [[LLModule sharedInstance] registerServiceWithServiceName:NSStringFromSelector(@selector(getInterestLabels)) URLPattern:@"ll://label.get" instance:NSStringFromClass(self)];
}

#pragma mark - LLModuleProtocol

- (void)initModule {
    NSLog(@"init Label Module.");
}

- (void)destroyModule {
    NSLog(@"destroy Label Module.");
}

- (void)callServiceWithURL:(NSString *)url
                parameters:(NSDictionary *)params
            navigationMode:(LLModuleNavigationMode)mode
              successBlock:(LLBasicSuccessBlock_t)success
              failureBlock:(LLBasicFailureBlock_t)failure {
    if ([LLUtils isNilOrEmtpyForString:url]) {
        failure(nil);
    }
    
    [[LLModule sharedInstance] callServiceWithCallerConnector:NSStringFromClass([self class]) URL:url parameters:params navigationMode:mode successBlock:success failureBlock:failure];
}

+ (NSArray *)relyService {
    return @[@"ll://storeData"];
}

#pragma mark - LabelModuleProtocol

+ (UIViewController *)showLabelModule {
    LabelModuleMainViewController *labelMainVC = [[LabelModuleMainViewController alloc] init];
    return labelMainVC;
}

+ (void)getInterestLabelsSuccessed:(LLSuccessBlock)success
                          failured:(LLFailureBlock)failure {
    [[LabelModuleLabelManager sharedLabelManager] getInsterestLabelsSuccessed:^(id result) {
        if (success) {
            success(result);
        }
    } failured:^(NSError *err) {
        if (failure) {
            failure(err);
        }
    }];
}

@end
