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
+(id) ObjectForJSONString:(NSString *) jsonString
{
    return [jsonString JSONValue];
}

+(NSString *) JSONStringForObject:(id) object
{
    return [object JSONRepresentation];
}

+(id) NilToSpace:(id)object{
    if (object ==nil) {
        return @"";
    }else {
        return object;
    }
}
@end
