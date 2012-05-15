//
//  HDBeanFactoryFromXML.m
//  hrms
//
//  Created by mas apple on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDBeanFactoryFromXML.h"

static HDBeanFactoryFromXML * _xmlFactory = nil;

@implementation HDBeanFactoryFromXML

@synthesize document=_document;

+(id)shareBeanFactory{
    @synchronized(self){
        if (_xmlFactory == nil) {
            _xmlFactory = [[self alloc] init];
        }
    }
    return  _xmlFactory;
}

+(id) allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (_xmlFactory == nil) {
            _xmlFactory = [super allocWithZone:zone];
            return  _xmlFactory;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    
    return self;
}

- (id)retain
{
    return self;
}

-(unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (id)autorelease
{
    return self;
}

-(void)dealloc
{
    TT_RELEASE_SAFELY(_document);
    [super dealloc];
}

-(id)init{
    self = [super init];
    NSError *error = nil;
    if (self) {
        NSString *url = [NSString stringWithFormat:@"%@services.xml",[[NSUserDefaults standardUserDefaults]stringForKey:@"base_url_preference"]];
        _document = [[CXMLDocument alloc]initWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding options:0 error:&error];
    }
    TTDPRINT(@"%@",error.description);
    
    return self;
}

-(id)getBeanWithDic:(NSDictionary *)data path:(NSString*)xpath{
    NSError *error = nil;
    CXMLNode *xPathNode;
    CXMLElement *xPathElement;
//    xPathNode = [_document nodeForXPath:@"/services/service[@name='aurora']/field-mappings/field-mapping[@url_name='APPROVE_TABLE_QUERY_URL']" error:&error];
    xPathNode = [_document nodeForXPath:xpath error:&error];
    
    if ([xPathNode isKindOfClass:[CXMLElement class]]) {
        xPathElement = (CXMLElement *)xPathNode;
        Class objectClass = NSClassFromString([[xPathElement attributeForName:@"class_name"]stringValue]);
        
        id object = [[objectClass alloc]init];
        
        NSArray *fieldsNodes = [_document nodesForXPath:[NSString stringWithFormat:@"%@/mapping",xpath] error:&error];
        for (CXMLElement *field in fieldsNodes) {
            [object setValue:[data valueForKey:[[field attributeForName:@"server"]stringValue]] forKeyPath:[[field attributeForName:@"client"]stringValue]];
        }
        
        return [object autorelease];
    }else {
        return nil;
    }
}
@end
