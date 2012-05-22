//
//  LoginModel.m
//  HRMS
//
//  Created by Rocky Lee on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDLoginModel.h"
#import "HDDataJSONFilter.h"
#import "HDDataAuroraFilter.h"
#import "ApproveDatabaseHelper.h"
#import "HDURLCenter.h"

static NSString * kLoginURLPath = @"LOGIN_PATH";

@implementation HDLoginModel

//登陆post数据
@synthesize username = _username;
@synthesize password = _password;
@synthesize result = _result;

@synthesize isAutoLogin = _isAutoLogin;
@synthesize isLoginSuccess = _isLoginSuccess;

+(BOOL)autoLogin
{
    HDLoginModel * loginModel = [[HDLoginModel alloc]init];
    loginModel.username = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    loginModel.password = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
    loginModel.isAutoLogin = YES;
        [loginModel load:TTURLRequestCachePolicyNetwork more:NO];
    //返回登录结果
    return loginModel.isLoginSuccess;
}

-(id)init
{
    if (self = [super init]) {
        _isAutoLogin = NO;
        _isLoginSuccess = NO;
    }
    return self;
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
    [[NSUserDefaults standardUserDefaults] setValue:_password forKey:@"password"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more
{
    //如果是不同用户登陆的,清空数据库
    [self initUsers];
    TTURLRequest *request = [TTURLRequest requestWithURL:[HDURLCenter requestURLWithKey:kLoginURLPath] delegate:self];
    
    request.cachePolicy = TTURLRequestCachePolicyNoCache;
    request.httpMethod = @"POST";
    request.multiPartForm = false;
    
    //这个从bean生成
    id postdata = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                   _username,@"user_name",
                   _password,@"user_password",
                   @"简体中文",@"langugae",
                   @"ZHS",@"user_language",
                   @"N",@"is_ipad", 
                   @"PHONE",@"device_type",
                   nil];
    
    NSError* error = nil;
    //这里从配置生成
    HDDataFilter * jsonParser = [[HDJSONToDataFilter alloc]initWithNextFilter:nil];
    HDDataFilter * parameterParser = [[HDDataAuroraRequestFilter alloc]initWithNextFilter:jsonParser];
    id result =  [parameterParser doFilter:postdata error:&error];

    TT_RELEASE_SAFELY(jsonParser);
    TT_RELEASE_SAFELY(parameterParser);
    
    [request.parameters setObject:result forKey:@"_request_data"];
    request.response = [[TTURLDataResponse alloc]init];
    if (_isAutoLogin) {
        [request sendSynchronously];
    }else {
        [request send];
    }
    
}

-(void)request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error
{
    TTDPRINT(@"request failed");
    [self didFailLoadWithError:error];
}

-(void)requestDidFinishLoad:(TTURLRequest *)request
{
    TTURLDataResponse * response = request.response;
    NSError *error =nil;
    
    HDDataFilter * dataParser = [[[HDDataAuroraResponseFilter alloc]initWithNextFilter:nil]autorelease];
    HDDataFilter * jsonParser = [[HDDataToJSONFilter alloc]initWithNextFilter:dataParser];
    
    _result = [jsonParser doFilter:response.data error:&error];
    [jsonParser release];
    
    if (!_result) {
        [self didFailLoadWithError:error];
    }else {
        _isLoginSuccess = YES;
        if (!_isAutoLogin) {
            [super requestDidFinishLoad:request];
        }              
    }
}

-(void)dealloc
{
    TT_RELEASE_SAFELY(_username);
    TT_RELEASE_SAFELY(_password);
    [super dealloc];
}

@end
