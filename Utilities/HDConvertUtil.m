//
//  HDConvertUtil.m
//  hrms
//
//  Created by Rocky Lee on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDConvertUtil.h"


@implementation HDConvertUtil

//json 数据的转换
+(id) objectForJSONString:(NSString *) jsonString
{
    return [jsonString JSONValue];
}

+(NSString *) JSONStringForObject:(id) object
{
    return [object JSONRepresentation];
}

+(id) ifNil:(id)theObject then:(id)convertObject
{
    if (theObject ==nil) {
        return convertObject;
    }else {
        return theObject;
    }
}
@end
