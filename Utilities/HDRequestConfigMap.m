//
//  HDRequestDelegateMap.m
//  hrms
//
//  Created by Rocky Lee on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDRequestConfigMap.h"

@implementation HDRequestConfig

@synthesize requestURL;
@synthesize requestData;

@synthesize delegate;
@synthesize successSelector;
@synthesize errorSelector;
@synthesize serverErrorSelector;
@synthesize failedSelector;

@synthesize ASIDidFinishSelector;
@synthesize ASIDidFailSelector;

@end

@implementation HDRequestConfigMap

-(id)init
{
    self = [super init];
    if (self) {
        _configMap = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (void)dealloc
{
    TT_RELEASE_SAFELY(_configMap);
    [super dealloc];
}

-(void)addConfig:(HDRequestConfig *) config forKey:(id) theKey
{
    [_configMap setObject:config forKey:theKey];
}

-(HDRequestConfig *) configForKey:(id) theKey
{
    return [_configMap objectForKey:theKey];
}

-(void) removeConfigForKey:(id) theKey
{
    [_configMap removeObjectForKey:theKey];
}


@end