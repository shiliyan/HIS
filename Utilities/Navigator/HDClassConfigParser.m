//
//  HDClassParser.m
//  Three20Lab
//
//  Created by Rocky Lee on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDClassConfigParser.h"
#import "HDGodXMLFactory.h"

static NSString * kClassConfigPath = @"/service/classes/class";
static NSString * kNibConfigPath = @"/service/nibs/nib";

@implementation HDClassConfigParser
@synthesize delegate = _delegate;

-(void)dealloc
{
    [super dealloc];
}

-(void)startParse
{
    [self parseNib];
    //parser classes node
    [self parseClass];    
}

-(id)readConfigWithKey:(NSString *) key
{
    NSError * error = nil;
    id config = [[[HDGodXMLFactory shareBeanFactory] document] nodesForXPath:key error:&error];
    if (nil != config) {
        return config;
    }
    TTDASSERT([error description]);
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
