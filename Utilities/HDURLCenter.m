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

//@synthesize baseURL = _baseURL;

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

-(NSString *) getURLWithKey:(id)key
{ 
    NSError *error = nil;
    NSString *url = nil;
    NSString *xpath = [NSString stringWithFormat:@"/service/urls/url[@name='%@']",key];
    HDBeanFactoryFromXML *factory = [HDBeanFactoryFromXML shareBeanFactory];
    
    CXMLNode *node = [factory.document nodeForXPath:xpath error:&error];
    
    if ([node isKindOfClass:[CXMLElement class]]) {
        url = [[((CXMLElement *)node) attributeForName:@"value"]stringValue];
    }
    
    return   [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"base_url_preference"],url];
}

+(NSString *) requestURLWithKey:(id)key
{
    return [[HDURLCenter sharedURLCenter] getURLWithKey:key];
}

@end
