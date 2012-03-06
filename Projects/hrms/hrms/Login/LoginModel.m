//
//  LoginModel.m
//  HRMS
//
//  Created by Rocky Lee on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginModel.h"

@implementation LoginModel

@synthesize username;
@synthesize password;
@synthesize languageDisplay;
@synthesize languageValue;

-(id) toDataSet{
    return  [NSDictionary dictionaryWithObjectsAndKeys:
             @"hand",@"user_name",
             @"hand",@"user_password",
             @"简体中文",@"langugae",
             @"ZHS",@"user_language",
             @"N",@"is_ipad", 
             nil];
}

-(void)dealloc{
    TT_RELEASE_SAFELY(username);
    TT_RELEASE_SAFELY(password);
    [super dealloc];
}
@end
