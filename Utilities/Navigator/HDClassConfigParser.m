//
//  HDClassParser.m
//  Three20Lab
//
//  Created by Rocky Lee on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDClassConfigParser.h"
#import "HDGodXMLFactory.h"

static NSString * kClassConfigPath = @"/backend-config/classes/class";
static NSString * kNibConfigPath = @"/backend-config/nibs/nib";

@implementation HDClassConfigParser
@synthesize delegate = _delegate;

-(void)startParse
{
    [self parseNib];
    //parser classes node
    [self parseClass];    
}

-(id)readConfigWithKey:(NSString *) key
{
    id config = [[HDGodXMLFactory shareBeanFactory] nodesForXPath:key];
    if (nil != config) {
        return config;
    }
    return nil;
}

-(void)parseNib
{   
    id nibConfig = [self readConfigWithKey:kNibConfigPath];
    if (nil == nibConfig) {
        return;
    }
    for (id node in nibConfig) {
        if ([node isKindOfClass:[CXMLElement class]]) {
            [_delegate performSelector:@selector(setNibLoadPathWithElement:) withObject:node];
        }
    }
}

-(void)parseClass
{
    id classConfig = [self readConfigWithKey:kClassConfigPath];
    if (nil == classConfig) {
        return;
    } 
    for (id node in classConfig) {
        if ([node isKindOfClass:[CXMLElement class]]) {
            [_delegate performSelector:@selector(setClassLoadPathWithElement:) withObject:node];         
        }
    }
}

@end
