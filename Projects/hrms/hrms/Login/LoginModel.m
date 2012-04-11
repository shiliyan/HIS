//
//  LoginModel.m
//  HRMS
//
//  Created by Rocky Lee on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginModel.h"
#import "HDFunctionUtil.h"
#import "HDURLCenter.h"
#import "HDHTTPRequestCenter.h"

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

- (id)init
{
    self = [super init];
    if (self) {
        HDRequestConfig * loginRequestConfig = [[HDRequestConfig alloc]init];
        [loginRequestConfig setDelegate:self];
        [loginRequestConfig setSuccessSelector:@selector(loginSVCSuccess:dataSet:)];
        [loginRequestConfig setServerErrorSelector:@selector(LoginError:errorMessage:)];
        [loginRequestConfig setErrorSelector:@selector(LoginError:errorMessage:)];
        [loginRequestConfig setFailedSelector:@selector(LoginError:errorMessage:)];
        
        HDRequestConfigMap * map = [[HDHTTPRequestCenter shareHTTPRequestCenter] requestConfigMap];
        [map addConfig:loginRequestConfig forKey:@"loginSVC"];
        
        [loginRequestConfig release];
    }
    return self;
}

-(void)dealloc
{
    [[[HDHTTPRequestCenter shareHTTPRequestCenter] requestConfigMap]removeConfigForKey:@"loginSVC"];
//    [[[HDHTTPRequestCenter shareHTTPRequestCenter] requestConfigMap]removeConfigForKey:@"sessionWrite"];
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
//    self.loginRequest  = [HDFormDataRequest hdRequestWithURL:[HDURLCenter requestURLWithKey:@"LOGIN_PATH"] 
//                                                    withData:[self generateLoginData]
//                                                     pattern:HDrequestPatternNormal];
    //注册回调
//    [_loginRequest setSuccessSelector:@selector(loginSVCSuccess:dataSet:)];
//    [_loginRequest setServerErrorSelector:@selector(LoginError:errorMessage:)];
//    [_loginRequest setErrorSelector:@selector(LoginError:errorMessage:)];
//    [_loginRequest setFailedSelector:@selector(LoginError:errorMessage:)];
    
    HDHTTPRequestCenter * requestCenter = [HDHTTPRequestCenter shareHTTPRequestCenter];
    NSLog(@"%@",[HDURLCenter requestURLWithKey:@"LOGIN_PATH"]);
    self.loginRequest = [requestCenter requestWithURL:[HDURLCenter requestURLWithKey:@"LOGIN_PATH"] 
                                             withData:[self generateLoginData] 
                                          requestType:HDRequestTypeFormData 
                                               forKey:@"loginSVC"];
    
    [_loginRequest startAsynchronous];
}

//取消登陆
-(void)cancelLogin
{
    [self.loginRequest cancel];
}

- (void)loginSVCSuccess:(ASIFormDataRequest *) request  dataSet:(NSArray *)dataSet
{
    SEL function = [HDFunctionUtil matchPerformDelegate:self.delegate 
                                           forSelectors:loginSuccessSelector,@selector(loginSuccess:),nil];
    if (function!=nil) {
        [delegate performSelector:function
                       withObject:dataSet];
    }else {
        NSLog(@"没有匹配的回调函数");
    }
}

- (void)LoginError:(ASIFormDataRequest *)request errorMessage: (NSString *)errorMessage
{    
    SEL function = [HDFunctionUtil matchPerformDelegate:self.delegate 
                                           forSelectors:loginFailedSelector,@selector(loginFailed:),nil];
    
    if (function!=nil) {
        [delegate performSelector:function
                       withObject:errorMessage];
    }else {
        NSLog(@"没有匹配的回调函数");
    }
}

@end
