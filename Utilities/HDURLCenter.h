//
//  HDURLCenter.h
//  hrms
//
//  Created by Rocky Lee on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDURLCenter : NSObject

@property (nonatomic,retain) NSString * baseURL;
@property (nonatomic,readonly) NSDictionary * theURLDictionary;

+(NSString *) requestURLWithKey:(id) key; 

@end
