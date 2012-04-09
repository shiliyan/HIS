//
//  NSDictionary+Addition.m
//  hrms
//
//  Created by Rocky Lee on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+HDAddition.h"

@implementation NSDictionary (HDAddition)

-(id)findObjectNotNilWithKeys:(id) key,...NS_REQUIRES_NIL_TERMINATION
{
id otherKey;
id node =[self objectForKey:key];
va_list argumentList;

if (node !=nil)
{
    va_start(argumentList, key);          
    while ((otherKey = va_arg(argumentList, id))){
        if([node objectForKey:otherKey] == nil)
        {
            return node;
        }else {
            node = [node objectForKey:otherKey];
        }
    }
    va_end(argumentList);
    return node;
}
return self;
}
@end
