//
//  HDBeanFactoryFromXML.h
//  hrms
//
//  Created by mas apple on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouchXML.h"

static NSString * kActionURLPathRootNodePath = @"/backend-config/runtime/action-path-mapping/map";
static NSString *kResourceRootPath = @"/backend-config/resources/resource";


@interface HDGodXMLFactory : NSObject{
    CXMLDocument *_document;
}

@property (nonatomic,readonly) CXMLDocument *document;
+(id)shareBeanFactory;

-(id)getBeanWithDic:(NSDictionary *)data path:(NSString*)xpath;

-(NSArray *)beansWithArray:(NSArray *) dataArray path:(NSString*)xpath;

//根据key获取action的urlpath
-(NSString *)actionURLPathWithKey:(NSString*) keyValue;

-(NSArray *) nodesForXPath:(NSString *)path;

-(NSString *)stringFroXPath:(NSString *)xpath attributeName:(NSString *) attName;
@end
