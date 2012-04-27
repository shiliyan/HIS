//
//  LoginModel.m
//  HRMS
//
//  Created by Rocky Lee on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDLoginModule.h"
#import "HDFunctionUtil.h"
#import "HDURLCenter.h"
#import "HDHTTPRequestCenter.h"
#import "ApproveDatabaseHelper.h"
@implementation HDLoginModule

//登陆请求
@synthesize loginRequest=_loginRequest;
//登陆post数据
@synthesize username = _username;
@synthesize password = _password;

//登陆协议 
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        //配置登录请求
        HDRequestConfig * loginRequestConfig = [[HDRequestConfig alloc]init];
        [loginRequestConfig setDelegate:self];
        [loginRequestConfig setSuccessSelector:@selector(loginSVCSuccess:dataSet:)];
        [loginRequestConfig setServerErrorSelector:@selector(LoginError:error:)];
        [loginRequestConfig setErrorSelector:@selector(LoginError:error:)];
        [loginRequestConfig setFailedSelector:@selector(LoginError:error:)];
        
        HDRequestConfigMap * map = [[HDHTTPRequestCenter shareHTTPRequestCenter] requestConfigMap];
        [map addConfig:loginRequestConfig forKey:@"loginSVC"];   
        [loginRequestConfig release];
        
        //获取用户名
         self.username = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    }
    return self;
}

-(void)dealloc
{
    [[[HDHTTPRequestCenter shareHTTPRequestCenter] requestConfigMap]removeConfigForKey:@"loginSVC"];
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
             _username,@"user_name",
             _password,@"user_password",
             @"简体中文",@"langugae",
             @"ZHS",@"user_language",
             @"N",@"is_ipad", 
             @"PHONE",@"device_type",
             nil];
}

-(void)login
{   
    TTDPRINT(@"%@",[HDURLCenter requestURLWithKey:@"LOGIN_PATH"]);
    
    //如果是不同用户登陆的,清空数据库
    [self initUsers];
    //发送登陆请求
    HDHTTPRequestCenter * requestCenter = [HDHTTPRequestCenter shareHTTPRequestCenter];
    self.loginRequest = [requestCenter requestWithURL:[HDURLCenter requestURLWithKey:@"LOGIN_PATH"] 
                                             withData:[self generateLoginData] 
                                          requestType:HDRequestTypeFormData 
                                               forKey:@"loginSVC"];
    [_loginRequest startAsynchronous];
}

-(void)initUsers
{
    //不同用户登录,清除数据库
    if (self.username != [[NSUserDefaults standardUserDefaults] valueForKey:@"username"]) {
        //
        ApproveDatabaseHelper * dbHelper = [[ApproveDatabaseHelper alloc]init];
        [dbHelper.db open];
        [dbHelper dropAllTables];
        [dbHelper.db close];
    }   
    [[NSUserDefaults standardUserDefaults] setValue:_username forKey:@"username"];
}
//取消登陆
-(void)cancelLogin
{
    [self.loginRequest cancel];
}

- (void)loginSVCSuccess:(ASIHTTPRequest *) request  dataSet:(NSArray *)dataSet
{
    SEL function = [HDFunctionUtil matchPerformDelegate:self.delegate 
                                           forSelectors:@selector(loginSuccess:),nil];
    if (function!=nil) {
        [delegate performSelector:function
                       withObject:dataSet];
    }else {
        NSLog(@"没有匹配的回调函数");
    }
}

- (void)LoginError:(ASIHTTPRequest *)request error: (NSDictionary *)errorObject
{    
    NSString * errorMessage =  [errorObject valueForKey:ERROR_MESSAGE];
    SEL function = [HDFunctionUtil matchPerformDelegate:self.delegate 
                                           forSelectors:@selector(loginFailed:),nil];
    
    if (function!=nil) {
        [delegate performSelector:function
                       withObject:errorMessage];
    }else {
        NSLog(@"没有匹配的回调函数");
    }
}

@end
