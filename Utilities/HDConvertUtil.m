//
//  HDConvertUtil.m
//  hrms
//
//  Created by Rocky Lee on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDConvertUtil.h"
#import "extThree20JSON/YAJL.h"

@implementation HDConvertUtil

//json 数据的转换
+(id) objectForJSONSData:(NSData *) jsonData
{
    NSError* error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:jsonData 
                                                options:NSJSONReadingMutableLeaves 
                                                  error:&error];
    if (!object) {
        // inspect error
        NSLog(@"%@", [error localizedDescription]);
    }
    [error release];
    return object;
}

+(NSString *) JSONStringForObject:(id) object
{
    NSError* error = nil;
    NSData * data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    NSString * JSONString = [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    if (!object) {
        // inspect error
        NSLog(@"%@", [error localizedDescription]);
    }
    return  JSONString;
}

@end
