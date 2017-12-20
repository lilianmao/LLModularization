//
//  StackForNSObject.h
//  LLModularization
//
//  Created by 李林 on 12/19/17.
//

#import <Foundation/Foundation.h>

@interface StackForNSObject : NSObject

- (BOOL)isEmpty;

- (NSInteger)size;

- (id)top;

- (BOOL)pushObj:(id)obj;

- (id)pop;

- (void)removeAllObjects;

- (NSArray *)getAllObjects;

@end
