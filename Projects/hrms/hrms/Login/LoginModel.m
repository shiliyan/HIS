//
//  LoginModel.m
//  HRMS
//
//  Created by Rocky Lee on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginModel.h"
#import "HDFunctionUtil.h"

@implementation LoginModel

//登陆请求
@synthesize loginRequest=_loginRequest;
//登陆post数据
@synthesize username = _username;
@synthesize password = _password;

//成功与失败的回调
@synthesize loginSuccessSelector;
@synthesize loginFailedSelector;

//登陆协议 
@synthesize delegate;

-(void)dealloc
{
    [self.loginRequest clearDelegatesAndCancel];
    TT_RELEASE_SAFELY(_loginRequest);
    TT_RELEASE_SAFELY(_username);
    TT_RELEASE_SAFELY(_password);
    [super dealloc];
}

-(id) generateLoginData
{
    return  [NSMutableDictionary dictionaryWithObjectsAndKeys:
             [[NSUserDefaults standardUserDefaults] stringForKey:@"deviceToken"],@"device_token",
             @"admin",@"user_name",
             @"admin",@"user_password",
             @"简体中文",@"langugae",
             @"ZHS",@"user_language",
             @"N",@"is_ipad", 
             @"1",@"company_id",
             @"41",@"role_id",
             nil];
}

-(void)login
{
    self.loginRequest  = [HDFormDataRequest hdRequestWithURL:kLoginURLPath 
                                                    withData:[self generateLoginData]
                                                     pattern:HDrequestPatternNormal];
    //注册回调
    [_loginRequest setSuccessSelector:@selector(successSelector:dataSet:)];
    [_loginRequest setServerErrorSelector:@selector(errorSelector:errorMessage:)];
    [_loginRequest setErrorSelector:@selector(errorSelector:errorMessage:)];
    [_loginRequest setAsiFaildSelector:@selector(errorSelector:errorMessage:)];
    
    [[_loginRequest setDelegate:self]startAsynchronous];
}

//取消登陆
-(void)cancelLogin
{
    [self.loginRequest cancel];
}

- (void)successSelector:(ASIFormDataRequest *) request  dataSet:(NSArray *)dataSet
{
    SEL function = [HDFunctionUtil matchPerformDelegate:self.delegate 
                                           forSelectors:loginSuccessSelector,
                    @selector(loginSuccess:),nil];
    if (function!=nil) {
        [delegate performSelector:function
                       withObject:dataSet];
    }else {
        NSLog(@"没有匹配的回调函数");
    }
}

- (void)errorSelector:(ASIFormDataRequest *)request errorMessage: (NSString *)errorMessage
{    
    SEL function = [HDFunctionUtil matchPerformDelegate:self.delegate 
                                           forSelectors:loginFailedSelector,
                    @selector(loginFailed:),nil];
    
    if (function!=nil) {
        [delegate performSelector:function
                       withObject:errorMessage];
    }else {
        NSLog(@"没有匹配的回调函数");
    }
}

@end
