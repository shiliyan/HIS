//
//  HDFunctionUtil.h
//  hrms
//
//  Created by Rocky Lee on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDFunctionUtil : NSObject

#pragma -mark 顺序匹配delegate和回调函数,如果delegate相应回调函数返回回调函数,如果没有匹配则返回nil
+(SEL) matchPerformDelegate:(id)theDelegate forSelectors:(SEL)selector, ... NS_REQUIRES_NIL_TERMINATION;

@end
