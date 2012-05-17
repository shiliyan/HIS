//
//  HDNavigator.h
//  Three20Lab
//
//  Created by Rocky Lee on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//#import "HDClassLoader.h"

@interface HDNavigator : TTNavigator

//@property(nonatomic,readonly) HDClassLoader * configLoader;
//@property(nonatomic,readonly) id objectDictionary;
//@property(nonatomic,readonly) id sysConfig;

+(HDNavigator *)navigator;

-(id)createObjectWithURLAction:(TTURLAction*)action;

//-(void)removeObjectWithURL:(NSString *)urlPath;

@end
