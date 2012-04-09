//
//  HDFunctionUtil.m
//  hrms
//
//  Created by Rocky Lee on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDFunctionUtil.h"

@implementation HDFunctionUtil

#pragma -mark 顺序匹配delegate和回调函数,如果delegate相应回调函数返回回调函数,如果没有匹配则返回nil
+(SEL) matchPerformDelegate:(id)theDelegate forSelectors:(SEL)selector,... NS_REQUIRES_NIL_TERMINATION
{
    SEL otherSelector;
    va_list argumentList;
    if (theDelegate && [theDelegate respondsToSelector:selector])
    {
        return selector;
    }else {                                   
        va_start(argumentList, selector);          
        while ((otherSelector = va_arg(argumentList, SEL))){
            if (theDelegate && [theDelegate respondsToSelector:otherSelector]) {
                return otherSelector;
            }
        }
        va_end(argumentList);
    }
    return nil;
}



@end
