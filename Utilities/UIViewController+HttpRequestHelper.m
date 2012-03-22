//
//  UIViewController+HttpRequestHelper.m
//  LoginDemo
//
//  Created by Stone Lee on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+HttpRequestHelper.h"

@implementation UIViewController (HttpRequestHelper)

-(void)formRequest:(NSString *)url 
          withData:(id) datas 
   successSelector:(SEL) successSelector 
    failedSelector:(SEL) failedSelector
     errorSelector:(SEL) errorSelector
 noNetworkSelector:(SEL) noNetworkSelector
{
    HDFormDataRequest * request = [HDFormDataRequest hdRequestWithURL:url pattern:0];
    [request setUseCookiePersistence:YES];
    [request setRequestCookies:[NSMutableArray arrayWithArray:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]]];
    
    //设置请求头
    NSMutableDictionary * headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"",
                                     nil];
    [request setRequestHeaders:headers];
    
    //设置回调函数
    [request setSuccessSelector:successSelector];
    [request setErrorSelector:errorSelector];
    
    if (datas) {
        [request setPostParameter:datas];
    }
    //设置代理
    //    [request setDelegate:self];  
    [request setDelegate:self];
    [request startAsynchronous];
}

-(ASIWebPageRequest *) webPageRequestConfig:(ASIWebPageRequest *) webPageRequest
                                        url:(NSString *) theURL
                              loadSucceeded:(SEL) failedSelector
                                 loadFailed:(SEL) scuccessSelector
{
    [webPageRequest setDelegate:nil];
    [webPageRequest cancel];
    
	[webPageRequest setDidFailSelector:@selector(failedSelector:)];
	[webPageRequest setDidFinishSelector:@selector(scuccessSelector:)];
	[webPageRequest setDelegate:self];
	[webPageRequest setDownloadProgressDelegate:self];
	[webPageRequest setUrlReplacementMode:ASIReplaceExternalResourcesWithData];
	
	// It is strongly recommended that you set both a downloadCache and a downloadDestinationPath for all ASIWebPageRequests
	[webPageRequest setDownloadCache:[ASIDownloadCache sharedCache]];
    /*
     *Q:这里是缓存策略，设置为不从缓存读取 ASIDoNotReadFromCacheCachePolicy
     */
	[webPageRequest setCachePolicy:ASIDoNotReadFromCacheCachePolicy|ASIDoNotWriteToCacheCachePolicy];
    
	// This is actually the most efficient way to set a download path for ASIWebPageRequest, as it writes to the cache directly
	[webPageRequest setDownloadDestinationPath:[[ASIDownloadCache sharedCache] pathToStoreCachedResponseDataForRequest:webPageRequest]];
	
	[[ASIDownloadCache sharedCache] setShouldRespectCacheControlHeaders:NO];
    return webPageRequest;
}


@end
