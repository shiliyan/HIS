//
//  HDNavigator.h
//  Three20Lab
//
//  Created by Rocky Lee on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//#import "HDClassLoader.h"

@interface HDNavigator : TTNavigator

+(HDNavigator *)navigator;

-(id)createObjectWithURLAction:(TTURLAction*)action;

@end
