//
//  HDBeanFactoryFromXML.h
//  hrms
//
//  Created by mas apple on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouchXML.h"

@interface HDBeanFactoryFromXML : NSObject{
    CXMLDocument *_document;
}

@property (nonatomic,readonly) CXMLDocument *document;
+(id)shareBeanFactory;

-(id)getBeanWithDic:(NSDictionary *)data path:(NSString*)xpath;
@end
