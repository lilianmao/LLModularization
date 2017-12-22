//
//  LLModuleTree.h
//  LLModularization
//
//  Created by 李林 on 12/22/17.
//

#import <Foundation/Foundation.h>

/**
 树的节点
 */
@interface LLModuleTreeNode : NSObject

@property (nonatomic, strong) NSArray<LLModuleTreeNode *> *childs;
@property (nonatomic, copy) NSString *moduleName;
@property (nonatomic, assign) int sequenceNumber;

- (instancetype)initTreeNodeWithModuleName:(NSString *)moduleName
                         andSequenceNumber:(int)sequenceNumber;

@end

@interface LLModuleTree : NSObject

@property (nonatomic, strong, readonly) LLModuleTreeNode *root;

+ (NSArray *)appendCaller:(NSString *)callerStr
                andCallee:(NSString *)calleeStr;

+ (NSArray *)popPage:(NSString *)page;

#warning 1. 非法pop一次或者多次 2. 各种判空以及for换成NSEnumator 3. 写一个全面的demo 

@end
