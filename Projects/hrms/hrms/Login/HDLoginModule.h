//
//  LoginModel.h
//  HRMS
//
//  Created by Rocky Lee on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HDLoginDelegate;

@interface HDLoginModule : NSObject{
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

@protocol HDLoginDelegate <NSObject>

@required

//登陆成功
-(void)loginSuccess:(NSArray *) dataSet;

//服务器登陆错误
-(void)loginFailed:(NSString *) errorMessage;

@end