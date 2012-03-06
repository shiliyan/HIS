//
//  UIViewController+HttpRequestHelper.m
//  LoginDemo
//
//  Created by Stone Lee on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+HttpRequestHelper.h"

@implementation UIViewController (HttpRequestHelper)

-(void)formRequest:(NSURL*)url 
          withData:(id) datas 
   successSelector:(SEL) successSelector 
    failedSelector:(SEL) failedSelector
     errorSelector:(SEL) errorSelector{
    //TODO:
    AuroraHTTPRequest * request = [AuroraHTTPRequest requestWithURL:url];
    [request setUseCookiePersistence:YES];
    [request setRequestCookies:[NSMutableArray arrayWithArray:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]]];
    
    //设置回调函数
    [request setSuccessSelector:successSelector];
    [request setFaildSelector:failedSelector];
    [request setErrorSelector:errorSelector];
    
    if (datas) {
        [request setPostParameter:datas];
    }
    //设置代理
//    [request setDelegate:self];  
    [request setAuroraDelegate:self];
    [request startAsynchronous];
}



@end
