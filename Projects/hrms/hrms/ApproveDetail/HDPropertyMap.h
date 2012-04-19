//
//  HDPropertyMap.h
//  hrms
//
//  Created by Rocky Lee on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface HDPropertyMap : NSObject
{
    NSDictionary * _mapDictionay;
}

+(id)convert:(NSDictionary *)dictionary;

@end
