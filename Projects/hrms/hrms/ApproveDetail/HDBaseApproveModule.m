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

-(id)initWithWebPageURL:(NSString *)theURL
{
    self = [super init];
    if (self) {
        self.webPageURL  = theURL;
    }
    return self;
}

-(void)dealloc
{
    [self loadCancel];
    TT_RELEASE_SAFELY(_actions);
    TT_RELEASE_SAFELY(_webPageURL);
    TT_RELEASE_SAFELY(_webPageRequest);
    [super dealloc];
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
    [self.actions loadTheActions];
}

//动作加载完成
-(void) actionsDidLoad:(NSArray *)actionsObject
{
    [self callActionDidLoad:actionsObject];
}

#pragma -mark action的代理方法
//设置动作加载参数 
-(id)actionsLoadParameterWithType:(NSString *)loadType
{
    return nil;
}

-(NSString *)actionsLoadPathWithType:(NSString *)loadType
{
    return nil;
}

//转换action回调信息为NSArray
-(NSArray *) transformToActionArray:(id) actionsObject 
{
    if (nil == actionsObject) {
        return [NSArray array];
    }else {
        return actionsObject;
    }
    
}

//通知界面动作加载完成
-(void) callActionDidLoad:(NSArray *) actionArray
{
    if (delegate && [delegate respondsToSelector:@selector(actionDidLoad:)]) {
        [delegate performSelector:@selector(actionDidLoad:)
                       withObject:actionArray];
    }else {
        NSLog(@"代理不响应actionLoad:方法");
    }
}

#pragma -mark 加载web页面
//加载webView
-(void)startLoadWebPage
{
    TTDPRINT(@"%@",_webPageURL);
    self.webPageRequest = [[HDHTTPRequestCenter shareHTTPRequestCenter] requestWithURL:_webPageURL
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
}

-(void)webPageLoadFailed:(ASIHTTPRequest *)theRequest
{
    [self callWebPageDidLoad:@"<h1>页面加载失败</h>" baseURL:[theRequest url]];
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
    TTDPRINT(@"web page content\n%@",webPageContent);
    [self callWebPageDidLoad:webPageContent baseURL:[theRequest url]];
}

//通知页面web页面加载完成 
-(void) callWebPageDidLoad:(NSString *)pageContent baseURL:(NSURL *)theBaseURL
{
    if (delegate && [delegate respondsToSelector:@selector(webPageDidLoad:baseURL:)]) {
        [delegate performSelector:@selector(webPageDidLoad:baseURL:) 
                       withObject:pageContent
                       withObject:theBaseURL];
    }else {
        NSLog(@"代理不响应webPageDidLoad:responseString:方法");
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

@end
