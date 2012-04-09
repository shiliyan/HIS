//
//  HDApproveDetailModel.m
//  hrms
//
//  Created by Rocky Lee on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDApproveDetailModel.h"
#import "HDURLCenter.h"

@implementation HDApproveDetailModel

@synthesize actionsRequest = _actionsRequest;
@synthesize webPageRequest = _webPageRequest;
@synthesize recordID = _recordID;
@synthesize actionID = _actionID;
@synthesize comment = _comment;
@synthesize screenName = _screenName;

//明细协议
@synthesize delegate;

-(id)initWithRecordID:(NSNumber *) theRecordID 
           screenName:(NSString *) theScreenName
{   
    self = [super init];
    if (self) {
        self.recordID = theRecordID;
        self.screenName = theScreenName;
    }
    return self;
}

-(void)dealloc
{
    [_actionsRequest clearDelegatesAndCancel];
    [_webPageRequest clearDelegatesAndCancel];
    TT_RELEASE_SAFELY(_actionsRequest);
    TT_RELEASE_SAFELY(_webPageRequest);
    TT_RELEASE_SAFELY(_recordID);
    TT_RELEASE_SAFELY(_actionID);
    [super dealloc];
}

-(void)loadWebPage{
    //创建页面载入请求
    NSString * screenUrl = [NSString stringWithFormat:@"%@%@?record_id=%i",[HDURLCenter requestURLWithKey:@"APPROVE_SCREEN_BASE_PATH"],_screenName,_recordID];
    
    self.webPageRequest = [ASIWebPageRequest requestWithURL:[NSURL URLWithString:screenUrl]];
    
    [_webPageRequest setUrlReplacementMode:ASIReplaceExternalResourcesWithData];
	[_webPageRequest setDownloadCache:[ASIDownloadCache sharedCache]];
	[_webPageRequest setCachePolicy:ASIDoNotReadFromCacheCachePolicy|ASIDoNotWriteToCacheCachePolicy];
	
    [_webPageRequest setDownloadDestinationPath:[[ASIDownloadCache sharedCache] pathToStoreCachedResponseDataForRequest:_webPageRequest]];
	[[ASIDownloadCache sharedCache] setShouldRespectCacheControlHeaders:NO];
    
	[_webPageRequest setDidFailSelector:@selector(webPageLoadFailed:)];
	[_webPageRequest setDidFinishSelector:@selector(webPageLoadSucceeded:)];
	[_webPageRequest setDelegate:self];
	[_webPageRequest setDownloadProgressDelegate:self];
    [_webPageRequest startAsynchronous];
    
}
-(void)loadWebActions{
//    NSLog(@"HDAppreoveDetailModel -68 \n\n%@",self.recordID);
    NSDictionary * data = [NSDictionary dictionaryWithObject:self.recordID forKey:@"record_id"];
    //////////////////////////////////////
    self.actionsRequest = [HDFormDataRequest hdRequestWithURL:[HDURLCenter requestURLWithKey:@"TOOLBAR_ACTION_QUERY_PATH"] 
                                                     withData:data
                                                      pattern:HDrequestPatternNormal];
    
    [_actionsRequest setSuccessSelector: @selector(callActionLoad:)];
    [_actionsRequest setDelegate:self];
    [_actionsRequest startAsynchronous];
}

-(void)loadCancel{
    [_webPageRequest clearDelegatesAndCancel];
    [_actionsRequest clearDelegatesAndCancel];
}

-(void)execAction
{
    NSDictionary * actionData = [NSDictionary dictionaryWithObjectsAndKeys:self.recordID,@"record_id",
                                 self.actionID,@"action_id",self.comment,@"comment" ,nil];
    //TODO:如何提交到队列
    HDFormDataRequest * actionRequest  = [HDFormDataRequest hdRequestWithURL:[HDURLCenter requestURLWithKey:@"EXEC_ACTION_UPDATE_PATH"] 
                                                     withData:actionData
                                                      pattern:HDrequestPatternNormal];
    
    [actionRequest setDelegate:self];
    [actionRequest setSuccessSelector:@selector(doActionSuccess:)];
    [actionRequest startAsynchronous];
}

-(void)execAction:(NSNumber *) theActionID
{
    if (theActionID != nil) {
        self.actionID = theActionID;
    }
    [self execAction];
}

#pragma -mark web Page load callback functions  
- (void)webPageLoadFailed:(ASIHTTPRequest *)theRequest
{
	NSLog(@"%@",[NSString stringWithFormat:@"Something went wrong: %@",[theRequest error]]);
    [self callWebPageLoad:theRequest webPageContent:@"<h1>页面加载失败</h>"];
}

- (void)webPageLoadSucceeded:(ASIHTTPRequest *)theRequest
{
    NSString * webPageContent;
    if([theRequest responseStatusCode] != 200)
    {
        webPageContent =  [theRequest responseStatusMessage];
    }else {
        if ([theRequest downloadDestinationPath])
        {
            webPageContent = [NSString stringWithContentsOfFile:[theRequest downloadDestinationPath] encoding:[theRequest responseEncoding] error:nil];
        } else {
            webPageContent = [theRequest responseString];
        }
    }
    
    [self callWebPageLoad:theRequest webPageContent:webPageContent];
}

-(void) callWebPageLoad:(ASIHTTPRequest *) theRequest webPageContent:(NSString *)pageContent
{
    if ([delegate respondsToSelector:@selector(webPageLoad:responseString:)]) {
        [delegate performSelector:@selector(webPageLoad:responseString:) 
                       withObject:theRequest 
                       withObject:pageContent];
    }else {
        NSLog(@"代理不响应该方法");
    }
}

-(void) callActionLoad:(NSArray *) dataSet
{
    if ([delegate respondsToSelector:@selector(actionLoad:)]) {
        [delegate performSelector:@selector(actionLoad:)
                       withObject:dataSet];
    }else {
        NSLog(@"代理不响应该方法");
    }
}

@end
