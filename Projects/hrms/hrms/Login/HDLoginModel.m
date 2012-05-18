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

-(id)initShouldAutoLogin:(BOOL) isAutoLogin
                   query:(NSDictionary *) query;
{
    if (self = [self init]) {
        [self.delegates addObject:[query objectForKey:@"delegate"]];
        self.username = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
        self.password = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
        if (!!isAutoLogin) {
            [self load:TTURLRequestCachePolicyNetwork more:NO];
        }
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
    [request.parameters setObject:result forKey:@"_request_data"];
    request.response = [[TTURLDataResponse alloc]init];
    [request send];
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
        [super requestDidFinishLoad:request];          
    }
}

-(void)dealloc
{
    TT_RELEASE_SAFELY(_username);
    TT_RELEASE_SAFELY(_password);
    [super dealloc];
}

@end
