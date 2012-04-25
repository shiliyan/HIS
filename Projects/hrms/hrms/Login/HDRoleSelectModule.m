//
//  HDRoleSelectModule.m
//  hrms
//
//  Created by Rocky Lee on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDRoleSelectModule.h"
#import "HDRequestConfigMap.h"
#import "HDHTTPRequestCenter.h"
#import "HDURLCenter.h"
#import "HDFunctionUtil.h"

@implementation HDRoleSelectModule

@synthesize roleSelectRequest = _roleSelectRequest;

@synthesize delegate;

-(id)initWithDataSet:(NSArray *)dataSet
{
    self = [self init];
    if (self) {
        _roleList = dataSet;
        [_roleList retain];
    }
    return self;
}

-(id)init
{
    self = [super init];
    if (self) {
        //配置登录请求
        HDRequestConfig * loginRequestConfig = [[HDRequestConfig alloc]init];
        [loginRequestConfig setDelegate:self];
        [loginRequestConfig setSuccessSelector:@selector(roleSelectSVCSuccess:dataSet:)];
        [loginRequestConfig setServerErrorSelector:@selector(roleSelectSVCError:error:)];
        [loginRequestConfig setErrorSelector:@selector(roleSelectSVCError:error:)];
        [loginRequestConfig setFailedSelector:@selector(roleSelectSVCError:error:)];
        HDRequestConfigMap * map = [[HDHTTPRequestCenter shareHTTPRequestCenter] requestConfigMap];
        [map addConfig:loginRequestConfig forKey:@"roleSelectSVC"];
        
        [loginRequestConfig release];
    }
    return self;
}

-(void)dealloc
{
    [[[HDHTTPRequestCenter shareHTTPRequestCenter] requestConfigMap]removeConfigForKey:@"roleSelectSVC"];
    [_roleSelectRequest clearDelegatesAndCancel];
    TT_RELEASE_SAFELY(_roleSelectRequest);
    TT_RELEASE_SAFELY(_roleList);
    [super dealloc];
}

-(NSUInteger)roleCount
{
    return [_roleList count];
}

-(id)roleAtIndex:(NSUInteger) index
{
    return [_roleList objectAtIndex:index];
}


-(void)selectRoleAtIndex:(NSUInteger) index
{   
    HDHTTPRequestCenter * requestCenter = [HDHTTPRequestCenter shareHTTPRequestCenter];
    self.roleSelectRequest = [requestCenter requestWithURL:[HDURLCenter requestURLWithKey:@"ROLE_SELECT_PATH"] 
                                                  withData:[_roleList objectAtIndex:index] 
                                               requestType:HDRequestTypeFormData 
                                                    forKey:@"roleSelectSVC"];
    
    [_roleSelectRequest startAsynchronous];
}

//取消登陆
-(void)cancelLogin
{
    [_roleSelectRequest cancel];
}

- (void)roleSelectSVCSuccess:(ASIHTTPRequest *) request dataSet:(NSArray *)dataSet
{
    SEL function = [HDFunctionUtil matchPerformDelegate:self.delegate 
                                           forSelectors:@selector(roleSelectSuccess:),nil];
    if (function!=nil) {
        [delegate performSelector:function
                       withObject:dataSet];
    }else {
        NSLog(@"没有匹配的回调函数");
    }
}

- (void)roleSelectSVCError:(ASIHTTPRequest *)request error: (NSDictionary *)errorObject
{    
    //    [errorObject valueForKey:@"code"];
    NSString * errorMessage =  [errorObject valueForKey:ERROR_MESSAGE];
    SEL function = [HDFunctionUtil matchPerformDelegate:self.delegate 
                                           forSelectors:@selector(roleSelectFailed:),nil];
    
    if (function!=nil) {
        [delegate performSelector:function
                       withObject:errorMessage];
    }else {
        NSLog(@"没有匹配的回调函数");
    }
}

@end
