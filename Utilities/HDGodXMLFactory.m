//
//  HDBeanFactoryFromXML.m
//  hrms
//
//  Created by mas apple on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDGodXMLFactory.h"

static HDGodXMLFactory * _xmlFactory = nil;

static NSString * kActionURLPathRootNodePath = @"/backend-config/runtime/action-path-mapping/map";
static NSString *kResourceRootPath = @"/backend-config/resources/resource";

@implementation HDGodXMLFactory

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
        NSString *url = [NSString stringWithFormat:@"%@ios-backend-config.xml",[[NSUserDefaults standardUserDefaults]stringForKey:@"base_url_preference"]];
//        NSData * data = [NSData dataWithContentsOfFile:@"/Users/Leo/Projects/xcode/HIS/Projects/hrms/hrms/services.xml"];
        _document = [[CXMLDocument alloc]initWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding options:0 error:&error];
//        _document = [[CXMLDocument alloc]initWithData:data encoding:NSUTF8StringEncoding options:0 error:&error];

    }
    TTDPRINT(@"%@",error.description);
    if (!_document) {
        return nil;
    }else {
        CXMLElement *rootElement = [_document rootElement];
        if ([[rootElement name] isEqualToString:@"backend-config"]) {
            return self;
        }else {
            return nil;
        }
    }
    
}

-(NSArray *)nodesForXPath:(NSString *)path
{
    NSError * error = nil;
    if (nil != _document) {
        id nodes = [_document nodesForXPath:path error:&error];
        if (nil != nodes) {
            return nodes;
        }
        TTDASSERT([error description]);
    }
    return nil;
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

-(NSArray *)beansWithArray:(NSArray *) dataArray path:(NSString*)xpath
{
    NSMutableArray * beanArray = [NSMutableArray array];
    for (NSDictionary * dic in dataArray) {
        id bean = [self getBeanWithDic:dic path:xpath];
        if (nil != bean) {
            [beanArray addObject:bean];
        }
    }
    return beanArray;
}

-(NSString *)actionURLPathWithKey:(NSString*) keyValue
{
    NSError *error = nil;
    NSString * xPathNodeURL = [NSString stringWithFormat:@"%@[@name='%@']",kActionURLPathRootNodePath,keyValue];
    id xPathNode = [_document nodeForXPath:xPathNodeURL error:&error];
    if ([xPathNode isKindOfClass:[CXMLElement class]]) {
        CXMLElement * xPathElement = xPathNode;
        return [[xPathElement attributeForName:@"url"]stringValue];
    }
    TTDPRINT(@"节点路径错误");
    return nil;
}

-(NSString *)stringFroXPath:(NSString *)xpath attributeName:(NSString *) attName{
    NSError *error = nil;
    id xPathNode = [_document nodeForXPath:xpath error:&error];
    if ([xPathNode isKindOfClass:[CXMLElement class]]) {
        CXMLElement * xPathElement = xPathNode;
        return [[xPathElement attributeForName:attName]stringValue];
    }
    return nil;
}


@end
