//
//  HDConfigLoader.h
//  Three20Lab
//
//  Created by Rocky Lee on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDClassConfigParser.h"

@interface HDClassLoader : NSObject<HDClassConfigParserDelegate>

-(void)startLoadClass;

@end
