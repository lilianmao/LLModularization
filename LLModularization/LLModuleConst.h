//
//  LLModuleConst.h
//  Pods
//
//  Created by 李林 on 12/14/17.
//

#ifndef LLModuleConst_h
#define LLModuleConst_h

#import <Foundation/Foundation.h>

typedef void (^LLBasicBlock_t)(void);
typedef void (^LLBasicSuccessBlock_t)(id result);
typedef void (^LLBasicFailureBlock_t)(NSError *err);
typedef void (^LLBasicCompletionBlock_t)(id result);

#endif /* LLModuleConst_h */
