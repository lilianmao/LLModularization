//
//  DataBase.h
//  modularizationDemo
//
//  Created by 李林 on 1/9/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBase : NSObject

+ (instancetype)sharedDataBase;

- (void)executeSQL:(NSString *)sql;

@end
