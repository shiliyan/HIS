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

-(NSString *) urlWithKey:(id)key query:(NSDictionary *)query
{ 
    NSError *error = nil;
    NSString *url = nil;
    NSString *xpath = [NSString stringWithFormat:@"/backend-config/urls/url[@name='%@']",key];
    HDGodXMLFactory *factory = [HDGodXMLFactory shareBeanFactory];
    
    CXMLNode *node = [factory.document nodeForXPath:xpath error:&error];
    
    if ([node isKindOfClass:[CXMLElement class]]) {
        url = [[((CXMLElement *)node) attributeForName:@"value"]stringValue];
    }
    
    //处理query参数替换
    NSEnumerator * e = [query keyEnumerator];
    for (NSString * key; (key = [e nextObject]);) {
        NSString * replaceString = [NSString stringWithFormat:@"[%@]",key];
        url = [url stringByReplacingOccurrencesOfString:replaceString withString:[query objectForKey:key]];
    }
    
    return   [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"base_url_preference"],url];
}

+(NSString *) requestURLWithKey:(id)key
{
    return [[HDURLCenter sharedURLCenter] urlWithKey:key query:nil];
}

+(NSString *) requestURLWithKey:(id)key query:(NSDictionary *)query
{
    return [[HDURLCenter sharedURLCenter] urlWithKey:key query:query];
}
@end
