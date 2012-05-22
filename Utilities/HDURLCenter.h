//
//  HDURLCenter.h
//  hrms
//
//  Created by Rocky Lee on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouchXML.h"

@interface HDURLCenter : NSObject

+(NSString *) requestURLWithKey:(id)key query:(NSDictionary *)query;

+(NSString *) requestURLWithKey:(id) key; 

@end
