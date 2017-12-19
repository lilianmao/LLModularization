//
//  StackForNSObject.m
//  LLModularization
//
//  Created by 李林 on 12/19/17.
//

#import "StackForNSObject.h"

@interface StackForNSObject()

@property (nonatomic, strong) NSMutableArray *stackArray;
@property (nonatomic, strong) Class itemClass;
@property (nonatomic, strong) NSRecursiveLock *lock;

@end

@implementation StackForNSObject

#pragma mark - init

- (instancetype)init {
    if (self  = [super init]) {
        [self initStack];
    }
    return self;
}

- (void)initStack {
    
}

- (NSMutableArray *)stackArray {
    if (!_stackArray) {
        _stackArray = @[].mutableCopy;
    }
    return _stackArray;
}

#pragma mark - API

- (BOOL)isEmpty {
    return [self stackArray].count==0;
}

- (NSInteger)size {
    return [self stackArray].count;
}

- (id)top {
    return [self stackArray].lastObject;
}

- (BOOL)pushObj:(id)obj {
    if ([self isEmpty]) {
        _itemClass = [obj class];
    } else if (![obj isKindOfClass:_itemClass]){
        return NO;
    }
    [self.lock lock];
    [self.stackArray addObject:obj];
    [self.lock unlock];
    return YES;
}

- (id)pop {
    if ([self isEmpty]) {
        return nil;
    } else {
        id lastObj = [self stackArray].lastObject;
        [self.lock lock];
        [self.stackArray removeLastObject];
        [self.lock unlock];
        return lastObj;
    }
}

- (void)removeAllObjects {
    self.stackArray = @[].mutableCopy;
}

- (NSArray *)getAllObjects {
    return [self arrayOfStack];
}

#pragma mark - Private Method

- (NSArray *)arrayOfStack {
    [self.lock lock];
    NSArray *array = [self.stackArray copy];
    [self.lock unlock];
    return array;
}

@end
