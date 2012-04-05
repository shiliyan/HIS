//
//  HDURLCenter.m
//  hrms
//
//  Created by Rocky Lee on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDURLCenter.h"

@implementation HDURLCenter

static HDURLCenter * _URLCenter = nil;

@synthesize baseURL = _baseURL;
@synthesize theURLDictionary = _theURLDictionary;

+(id) sharedURLCenter
{
    @synchronized(self){
        if (_URLCenter == nil) {
            _URLCenter = [[self alloc] init];
        }
    }
    return  _URLCenter;
}

+(id) allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (_URLCenter == nil) {
            _URLCenter = [super allocWithZone:zone];
            return  _URLCenter;
        }
    }
    return nil;
}

-(id)init
{
    self = [super init];
    if (self) {
        NSString *path =[[NSBundle mainBundle] pathForResource:@"URLSetting" ofType:@"plist"];
        _theURLDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    }
    return self;
}

-(void)dealloc
{
    [_theURLDictionary release];
    [_URLCenter release];
    [super dealloc];
}

-(NSString *) getURLWithKey:(id)key
{
    return   [NSString stringWithFormat:@"%@%@",[self.theURLDictionary valueForKey:@"BASE_URL"],[self.theURLDictionary valueForKey:key]];
}

+(NSString *) requestURLWithKey:(id)key
{
    return [[HDURLCenter sharedURLCenter] getURLWithKey:key];
}

@end
