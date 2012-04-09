//
//  LoginModel.h
//  HRMS
//
//  Created by Rocky Lee on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDLoginDelegate.h"
#import "HDFormDataRequestDelegate.h"

@interface LoginModel : NSObject{
    id <HDLoginDelegate> delegate;
}

@property (assign) SEL loginSuccessSelector;
@property (assign) SEL loginFailedSelector;

@property (nonatomic,retain) HDFormDataRequest * loginRequest;
@property (nonatomic,retain) NSString * username;
@property (nonatomic,retain) NSString * password;
@property (nonatomic,assign) id <HDLoginDelegate> delegate;

-(void)login;

@end

