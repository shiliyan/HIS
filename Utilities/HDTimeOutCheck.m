//
//  HDTimeOutCheck.m
//  hrms
//
//  Created by Rocky Lee on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDTimeOutCheck.h"
#import "HDDataFilter.h"
#import "HDDataAuroraFilter.h"
#import "HDDataJSONFilter.h"

static NSString * kTimeOutCheckPath = @"SYS_TIME_OUT_CHECK_PATH";

@implementation HDTimeOutCheck
@synthesize isTimeOut = _isTimeOut;

+(BOOL)isTimeOut
{
    HDTimeOutCheck * timeOutCheck = [[[HDTimeOutCheck alloc]init] autorelease];
    return [timeOutCheck check];
    
}

-(BOOL)check
{
    NSString * timeOutCheckUrl = [HDURLCenter requestURLWithKey:kTimeOutCheckPath];
    TTURLRequest * request = [TTURLRequest requestWithURL:timeOutCheckUrl delegate:self];
    request.cachePolicy = TTURLRequestCachePolicyNoCache;
    request.response = [[[TTURLDataResponse alloc]init] autorelease];
    [request sendSynchronously];
    return _isTimeOut;
}

-(void)requestDidFinishLoad:(TTURLRequest *)request
{
    TTURLDataResponse * response = request.response;
    NSError *error =nil;
    
    HDDataFilter * dataParser = [[[HDDataAuroraResponseFilter alloc]initWithNextFilter:nil]autorelease];
    HDDataFilter * jsonParser = [[HDDataToJSONFilter alloc]initWithNextFilter:dataParser];
    
    NSArray * dataSet = [jsonParser doFilter:response.data error:&error];
    [jsonParser release];
    
    if (!dataSet) {
        TTDPRINT(@"无法解析返回数据");
    }else {
         _isTimeOut = [[[dataSet lastObject] valueForKeyPath:@"is_time_out"] boolValue];
    }
}

-(void)request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error
{
    TTDPRINT(@"%@",[error description]);
    TTDPRINT(@"超时校验路径错误");
    _isTimeOut = NO;
}

@end
