//
//  HDPropertyMap.m
//  hrms
//
//  Created by Rocky Lee on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDPropertyMap.h"

static HDPropertyMap * _propertyMap = nil;

@implementation HDPropertyMap

+(id)sharePropertyMap
{    
    @synchronized(self)
    {
        if (_propertyMap == nil) 
        {
            _propertyMap = [[self alloc] init];
        }
    }
    return  _propertyMap;
}

+(id) allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (_propertyMap == nil) 
        {
            _propertyMap = [super allocWithZone:zone];
            return  _propertyMap;
        }
    }
    return nil;
}

-(id)init
{
    self = [super init];
    if (self) {
        NSString *path =[[NSBundle mainBundle] pathForResource:@"propertyMap" ofType:@"plist"];
        _mapDictionay = [[NSDictionary alloc] initWithContentsOfFile:path];
    }
    return self;    
}

-(void)dealloc
{
    TT_RELEASE_SAFELY(_propertyMap);
    [super dealloc];
}

+(id)convert:(NSDictionary *)dictionary
{
    return [[HDPropertyMap sharePropertyMap] convert:dictionary];
}

-(id)convert:(NSDictionary *)dictionary
{
    NSArray * keyArray =  [dictionary allKeys];
    NSMutableDictionary * newDictionary = [NSMutableDictionary dictionary];
    for (NSString * key  in keyArray) {
        //从map中获取映射的key
        NSString * mapKey = [_mapDictionay valueForKey:key];
        //设置key为映射后的key
        if (mapKey) {
            [newDictionary setValue:[dictionary valueForKey:key] forKey:mapKey];
        }else {
            NSLog(@"can't convert key for %@,make sure you set the mapping in propertyMap.plist",key);
        }
    }
    return newDictionary;
}

@end
