//
//  NSDictionary+Addition.h
//  hrms
//
//  Created by Rocky Lee on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (HDAddition)

-(id)findObjectNotNilWithKeys:(NSString *) key,...NS_REQUIRES_NIL_TERMINATION;

@end
