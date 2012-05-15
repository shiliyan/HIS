//
//  HDJSONParser.m
//  Three20Lab
//
//  Created by Rocky Lee on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDataJSONFilter.h"

@implementation HDDataToJSONFilter

-(id)doFilter:(id)data error:(NSError **)error
{
    if ([data isKindOfClass:[NSData class]]) {
        id object = [NSJSONSerialization JSONObjectWithData:data 
                                                    options:NSJSONReadingMutableLeaves 
                                                      error:error];
        if (nil != object) {
            return [self doNextFilter:object error:error];
        }   
    }
    return [self errorWithData:data error:error];
}

@end

@implementation HDJSONToDataFilter

-(id)doFilter:(id)data error:(NSError **)error
{
    if ([data isKindOfClass:[NSDictionary class]]||
        [data isKindOfClass:[NSArray class]]){
        id jsonData = [NSJSONSerialization dataWithJSONObject:data 
                                                      options:0
                                                        error:error];
        if (nil != jsonData) {
            return [self doNextFilter:jsonData error:error];
        }
    }
    return [self errorWithData:data error:error];
}
@end
