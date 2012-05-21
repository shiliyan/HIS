//
//  HDHTTPRequestCenter.h
//  hrms
//
//  Created by Rocky Lee on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
/*
 *http 请求中心:
 *所有的http请求代理到这里请求,解决请求创建和delegate为不同对象的问题
 *
 */
#import <Foundation/Foundation.h>
#import "ASIWebPageRequest.h"
#import "HDFormDataRequest.h"
#import "HDRequestConfigMap.h"

typedef enum {
    HDRequestTypeFormData = 0,
    ASIRequestTypeWebPage = 1,
    TTRequest = 2,
} HDRequestType;

@interface HDHTTPRequestCenter : TTURLRequestModel

@property (nonatomic,readonly) HDRequestConfigMap * requestConfigMap;
//最后一次请求时间
@property (nonatomic,readonly) NSDate * lastRequestTime;
@property (nonatomic,readonly) NSUInteger LoginTimes;
@property (nonatomic,readonly) BOOL isTimeOut;
//@property (nonatomic,readonly) BOOL isOnline;

+(id)shareHTTPRequestCenter;

//创建请求,然后返回一个request
-(id)requestWithURL:(NSString *)newURL
        requestType:(HDRequestType) requestType
             forKey:(id)requestConfigKey;

-(id)requestWithURL:(NSString *)newURL 
           withData:(id) data 
        requestType:(HDRequestType) requestType
             forKey:(id)requestConfigKey;

-(id)requestWithKey:(id)requestConfigKey 
        requestType:(HDRequestType)requestType;
@end
