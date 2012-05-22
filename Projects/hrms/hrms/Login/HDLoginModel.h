//
//  LoginModel.h
//  HRMS
//
//  Created by Rocky Lee on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDLoginModel : TTURLRequestModel

@property (nonatomic,retain) NSString * username;
@property (nonatomic,retain) NSString * password;

@property (nonatomic,retain) id result;
@property (nonatomic,assign) BOOL isAutoLogin;
@property (nonatomic,readonly) BOOL isLoginSuccess;

+(BOOL)autoLogin;

@end
