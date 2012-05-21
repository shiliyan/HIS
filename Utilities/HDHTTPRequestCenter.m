//
//  HDHTTPRequestCenter.m
//  hrms
//
//  Created by Rocky Lee on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDHTTPRequestCenter.h"
#import "HDRequestConfigMap.h"
#import "ASIDownloadCache.h"
#import <objc/runtime.h>
#import "HDTimeOutCheck.h"
#import "HDLoginModel.h"

@implementation HDHTTPRequestCenter

static HDHTTPRequestCenter * _requestCenter = nil;

@synthesize requestConfigMap = _requestConfigMap;
@synthesize lastRequestTime = _lastRequestTime;
@synthesize LoginTimes = _LoginTimes;

@synthesize isTimeOut = _isTimeOut;

+(id)shareHTTPRequestCenter
{
    @synchronized(self){
        if (_requestCenter == nil) {
            _requestCenter = [[self alloc] init];
        }
    }
    return  _requestCenter;
}

+(id) allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (_requestCenter == nil) {
            _requestCenter = [super allocWithZone:zone];
            return  _requestCenter;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

-(id)init
{
    self = [super init];
    if (self) {
        _requestConfigMap = [[HDRequestConfigMap alloc]init];
        _lastRequestTime =[[NSDate dateWithTimeIntervalSinceNow:0] retain];
        _LoginTimes = 0;
        _isTimeOut = NO;
    }
    return self;
}

-(unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (id)autorelease
{
    return self;
}

-(void)dealloc
{
    TT_RELEASE_SAFELY(_requestConfigMap);
    TT_RELEASE_SAFELY(_lastRequestTime);
    [super dealloc];
}

//根据指定delegate号码创建请求 
-(id)requestWithURL:(NSString *)newURL
        requestType:(HDRequestType) requestType
             forKey:(id)requestConfigKey
{
    return [self requestWithURL:newURL 
                       withData:nil
                    requestType:requestType 
                         forKey:requestConfigKey];
}

-(id)requestWithKey:(id)requestConfigKey 
        requestType:(HDRequestType)requestType
{
    HDRequestConfig * config = [self.requestConfigMap configForKey:requestConfigKey];
    
    return [self requestWithURL:[config requestURL] 
                       withData:[config requestData] 
                    requestType:requestType
                         forKey:requestConfigKey];
}

//根据传入参数生成request
-(id)requestWithURL:(NSString *)newURL 
           withData:(id) data 
        requestType:(HDRequestType) requestType
             forKey:(id)requestConfigKey
{
    //TODO:暂时不处理超时的问题
//    [self checkSession];
//    if ([self shouldShowLogin]) {
//        //如果判断需要返回登陆界面,向消息中心发送消息,并return
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"show_login_view" object:nil];
//        return nil;
//    }
    
    //根据请求参数生成请求对象
    switch (requestType) {
        case HDRequestTypeFormData:
        {
            HDRequestConfig * config = [self.requestConfigMap configForKey:requestConfigKey];
            HDFormDataRequest * theRequest = 
            [HDFormDataRequest hdRequestWithURL:newURL 
                                       withData:data
                                        pattern:HDrequestPatternNormal];
            
            [theRequest setDelegate:config.delegate];
            [theRequest setSuccessSelector:config.successSelector];
            [theRequest setErrorSelector:config.errorSelector];
            [theRequest setServerErrorSelector:config.serverErrorSelector];
            [theRequest setFailedSelector:config.failedSelector];  
            [theRequest setTimeOutSeconds:30];
            [theRequest setTag:config.tag];
            return theRequest;
            break;
        }
            
        case ASIRequestTypeWebPage:
        {
            HDRequestConfig * config = [self.requestConfigMap configForKey:requestConfigKey];
            ASIWebPageRequest * theRequest = [ASIWebPageRequest requestWithURL:[NSURL URLWithString:newURL]];
            [theRequest setDelegate:config.delegate];
            [theRequest setDidFinishSelector:config.ASIDidFinishSelector];
            [theRequest setDidFailSelector:config.ASIDidFailSelector];
            [theRequest setUrlReplacementMode:ASIReplaceExternalResourcesWithData];
            [theRequest setShouldAttemptPersistentConnection:NO];
            //debug:这里设置问不修嘎url 否则会导致auroa加载资源失败
            [theRequest setShouldIgnoreExternalResourceErrors:NO];
            [theRequest setDownloadCache:[ASIDownloadCache sharedCache]];
            [theRequest setCachePolicy:ASIUseDefaultCachePolicy];
            [theRequest setDownloadDestinationPath:[[ASIDownloadCache sharedCache]pathToStoreCachedResponseDataForRequest:theRequest]];
            [theRequest setTimeOutSeconds:30];
            [[ASIDownloadCache sharedCache] setShouldRespectCacheControlHeaders:NO];
            return theRequest;
        } 
        case TTRequest:
        {
            TTURLRequest * theRequest = [TTURLRequest request];
            theRequest.cachePolicy = TTURLRequestCachePolicyNoCache;
            theRequest.httpMethod = @"POST";
            theRequest.multiPartForm = false;
            theRequest.response = [[[TTURLDataResponse alloc]init] autorelease];
            return theRequest;
        }
        default:
            break; 
    } 
}

//判断是否返回登录界面,yes,退回登录界面,返回no继续请求
-(BOOL)shouldShowLogin
{
    return _isTimeOut;
}

//校验session并尝试自动登录
-(void)checkSession
{
    //在返回请求之前,校验session是否存在
    NSDate * now = [NSDate dateWithTimeIntervalSinceNow:0];
    //如果距离上次请求超过1800秒,发起校验
    if ([now timeIntervalSinceDate:_lastRequestTime]>1800) {
        //校验是否超时
        [self checkTimeOut];
        [self autoLogin];
    }
    //刷新最后一次更新时间
    if (nil != _lastRequestTime) {
        TT_RELEASE_SAFELY(_lastRequestTime);
    }
    _lastRequestTime = [now retain];
}

//检查超时
-(void)checkTimeOut
{
    _isTimeOut = [HDTimeOutCheck isTimeOut];
}

-(void)autoLogin
{
    //如果未超时返回
    if (_isTimeOut == NO) {
        return;
    }
    //如果不是第一次登录返回
    if (_LoginTimes >= 2) {
        return;
    }
    _LoginTimes ++;
    //发起登录请求
    _isTimeOut = ![HDLoginModel autoLogin];
    if (_isTimeOut) {
        [self autoLogin];
    } 
}

@end
