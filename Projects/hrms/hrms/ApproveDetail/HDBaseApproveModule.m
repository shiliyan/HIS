//
//  HDBaseApprove.m
//  hrms
//
//  Created by Rocky Lee on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDBaseApproveModule.h"
#import "HDHTTPRequestCenter.h"

@implementation HDBaseApproveModule

@synthesize delegate;
@synthesize actions = _actions;
@synthesize webPageURL = _webPageURL;
@synthesize webPageRequest = _webPageRequest;

-(void)dealloc
{
    [super dealloc];
    [self loadCancel];
    TT_RELEASE_SAFELY(_actions);
    TT_RELEASE_SAFELY(_webPageURL);
    TT_RELEASE_SAFELY(_webPageRequest);
}

//加载动作
-(void)startLoad
{
    //加载动作
    [self startLoadAction];
    //加载web页面 
    [self startLoadWebPage];
}

#pragma -mark 加载动作
//加载动作
-(void)startLoadAction
{
    //设置动作加载
    if (nil == _actions) {
        [self setActions:[HDBaseActions actionsModule]];
    }
    _actions.delegate = self;
    _actions.didLoadSelector = @selector(actionDidLoadSelector:);
    //动作加载参数前,可以配置action的参数,这里考虑调用的位置,如果在delegate的配置之后,则外部可以打断回调路径,直接获取回调的信息 
    [self beforeLoadActions:_actions];
    [self.actions loadActions];
}

//动作加载开始前,配置加载参数
-(void)beforeLoadActions:(HDBaseActions *) actionModule
{

}

//动作加载完成
-(void) actionDidLoadSelector:(id) actionsObject
{
    [self callActionLoad:[self transformToActionArray:actionsObject]];
}

//转换action回调信息为NSArray
-(NSArray *) transformToActionArray:(id) actionsObject 
{
    return actionsObject;
}

//通知界面动作加载完成
-(void) callActionLoad:(NSArray *) actionArray
{
    if (delegate && [delegate respondsToSelector:@selector(actionLoad:)]) {
        [delegate performSelector:@selector(actionLoad:)
                       withObject:actionArray];
    }else {
        NSLog(@"代理不响应actionLoad:方法");
    }
}

#pragma -mark 加载web页面
//加载webView
-(void)startLoadWebPage
{
    //创建页面载入请求 
//    if (nil == self.webPageURL) {
//        [self callWebPageLoad:@"<h1>审批的URL未指定</h>" baseURL:nil];
//        return;
//    }
    NSLog(@"%@",self.webPageURL);
    _webPageRequest = [[HDHTTPRequestCenter shareHTTPRequestCenter] requestWithURL:self.webPageURL
                                                                       requestType:ASIRequestTypeWebPage 
                                                                            forKey:nil];
    
	[_webPageRequest setDidFailSelector:@selector(webPageLoadFailed:)];
	[_webPageRequest setDidFinishSelector:@selector(webPageLoadSucceeded:)];
	[_webPageRequest setDelegate:self];
	[_webPageRequest setDownloadProgressDelegate:self];
    
    //webpage加载前,可以配置request参数 这里考虑调用的位置,如果在delegate的配置之后,则外部可以打断回调路径,直接获取回调的信息
    [self beforeLoadWebPage:_webPageRequest];
    [_webPageRequest startAsynchronous];
}

//动作加载开始前,配置加载参数
-(void)beforeLoadWebPage:(ASIWebPageRequest *) webPageRequest
{
    NSLog(@"%@",webPageRequest.url.URLValue);
}

-(void)webPageLoadFailed:(ASIHTTPRequest *)theRequest
{
    [self callWebPageLoad:@"<h1>页面加载失败</h>" baseURL:[theRequest url]];
}

-(void)webPageLoadSucceeded:(ASIHTTPRequest *)theRequest
{
    NSString * webPageContent;
    if([theRequest responseStatusCode] == 200)
    {
        if ([theRequest downloadDestinationPath])
        {
            webPageContent = [NSString stringWithContentsOfFile:[theRequest downloadDestinationPath] encoding:[theRequest responseEncoding] error:nil];
        } else {
            webPageContent = [theRequest responseString];
        }
    } else {
        webPageContent =  [theRequest responseStatusMessage];
    }
    
    [self callWebPageLoad:webPageContent baseURL:[theRequest url]];
}

//通知页面web页面加载完成 
-(void) callWebPageLoad:(NSString *)pageContent baseURL:(NSURL *)theBaseURL
{
    if (delegate && [delegate respondsToSelector:@selector(webPageLoad:baseURL:)]) {
        [delegate performSelector:@selector(webPageLoad:baseURL:) 
                       withObject:pageContent
                       withObject:theBaseURL];
    }else {
        NSLog(@"代理不响应webPageLoad:responseString:方法");
    }
}

//取消加载
-(void)loadCancel
{
    [_webPageRequest clearDelegatesAndCancel];
    [_actions cancelLoadingActions];
}

//审批
-(void)submitApprove{}

//-(void)webPageLoad:(NSString *)htmlString baseURL:(NSURL *)theBaseURL{}

//-(void)actionLoad:(NSArray *) actionArray{}

@end
