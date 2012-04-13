//
//  HDApproveDetailModel.m
//  hrms
//
//  Created by Rocky Lee on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDApproveDetailModel.h"
#import "HDURLCenter.h"
#import "HDHTTPRequestCenter.h"

static NSString * kExecAction = @"execAction";

@implementation HDApproveDetailModel

@synthesize actionsRequest = _actionsRequest;
@synthesize webPageRequest = _webPageRequest;
@synthesize recordID = _recordID;
@synthesize actionID = _actionID;
@synthesize comment = _comment;
@synthesize screenName = _screenName;
@synthesize dbHelper = _dbHelper;

//明细协议
@synthesize delegate;

-(id)initWithRecordID:(NSNumber *) theRecordID 
           screenName:(NSString *) theScreenName
{   
    self = [super init];
    if (self) {
        self.recordID = theRecordID;
        self.screenName = theScreenName;
        //
//        HDRequestConfig * execActionRequestConfig = [[HDRequestConfig alloc]init];
//        [execActionRequestConfig setDelegate:self];
//        [execActionRequestConfig setSuccessSelector:@selector(doActionSuccess:dataSet:)];
//        [execActionRequestConfig setServerErrorSelector:@selector(doActionFailed:errorMessage:)];
//        [execActionRequestConfig setErrorSelector:@selector(doActionFailed:errorMessage:)];
//        [execActionRequestConfig setFailedSelector:@selector(doActionFailed:errorMessage:)];  
//        
//        HDRequestConfigMap * map = [[HDHTTPRequestCenter shareHTTPRequestCenter] requestConfigMap];
//        [map addConfig:execActionRequestConfig forKey:kExecAction];
//        [execActionRequestConfig release];
    }
    return self;
}

-(void)dealloc
{
    [[[HDHTTPRequestCenter shareHTTPRequestCenter] requestConfigMap] removeConfigForKey:kExecAction];
    [_actionsRequest clearDelegatesAndCancel];
    [_webPageRequest clearDelegatesAndCancel];
    TT_RELEASE_SAFELY(_actionsRequest);
    TT_RELEASE_SAFELY(_webPageRequest);
    TT_RELEASE_SAFELY(_recordID);
    TT_RELEASE_SAFELY(_actionID);
    TT_RELEASE_SAFELY(_dbHelper);
    [super dealloc];
}

-(void)loadWebPage{
    //创建页面载入请求
    NSString * screenUrl = [NSString stringWithFormat:@"%@%@?record_id=%@",[HDURLCenter requestURLWithKey:@"APPROVE_SCREEN_BASE_PATH"],_screenName,_recordID];
    
    self.webPageRequest = [[HDHTTPRequestCenter shareHTTPRequestCenter] requestWithURL:screenUrl requestType:ASIRequestTypeWebPage forKey:nil];
    
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
    
    [_actionsRequest setSuccessSelector: @selector(callActionLoad:withDataSet:)];
    [_actionsRequest setDelegate:self];
    [_actionsRequest startAsynchronous];
}

-(void)loadCancel{
    [_webPageRequest clearDelegatesAndCancel];
    [_actionsRequest clearDelegatesAndCancel];
}

-(void)execAction
{
    NSDictionary * actionData = [NSDictionary dictionaryWithObjectsAndKeys:self.recordID,@"record_id", self.actionID,@"action_id", self.comment,@"comment", nil];
    //TODO:配置请求
    HDRequestConfigMap * map = [[HDHTTPRequestCenter shareHTTPRequestCenter] requestConfigMap];
    HDRequestConfig * execActionRequestConfig  = [map configForKey:@"detial_ready_post"];
    [execActionRequestConfig setRequestURL:[HDURLCenter requestURLWithKey:@"EXEC_ACTION_UPDATE_PATH"]];
    [execActionRequestConfig setRequestData:actionData];
    
    
    
//    HDHTTPRequestCenter * requestCenter = [HDHTTPRequestCenter shareHTTPRequestCenter];
//    HDFormDataRequest * actionRequest = [requestCenter requestWithURL:[HDURLCenter requestURLWithKey:@"EXEC_ACTION_UPDATE_PATH"] 
//                                                             withData:actionData 
//                                                          requestType:HDRequestTypeFormData 
//                                                               forKey:kExecAction];
//    [actionRequest startAsynchronous];
}

//-(void)execAction:(NSNumber *) theActionID
//{
//    if (theActionID != nil) {
//        self.actionID = theActionID;
//    }
//    [self execAction];
//}

-(void)removeLocalData :(NSNumber *) recordID
{
//  写数据库
//  初始化数据库连接
    _dbHelper = [[ApproveDatabaseHelper alloc]init];
    
    [_dbHelper.db open];
    NSString * sql = [NSString stringWithFormat:@"delete from %@ where %@ = %@",@"approve_list",@"record_id",self.recordID];
    NSLog(@"%@",sql);
    [_dbHelper.db executeUpdate:sql];
    [_dbHelper.db close];
    
    [_dbHelper release];
}

#pragma -mark exec action callback functions
-(void)doActionSuccess:(ASIHTTPRequest *) theRequest dataSet:(NSMutableArray *) dataSet
{
    //执行成功
    [self removeLocalData:self.recordID];
    [self callExecActionSuccess:theRequest withDataSet:dataSet];
}    

-(void) doActionFailed:(ASIHTTPRequest *) theRequest errorMessage:(NSString *) errorMessage
{
    //执行失败
    [self callExecActionFailed:theRequest withErrorMessage:errorMessage];
}

#pragma -mark web Page load callback functions  
- (void)webPageLoadFailed:(ASIHTTPRequest *)theRequest
{
//	NSLog(@"%@",[NSString stringWithFormat:@"Something went wrong: %@",[theRequest error]]);
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

#pragma -mark 操作回调
-(void) callWebPageLoad:(ASIHTTPRequest *) theRequest webPageContent:(NSString *)pageContent
{
    if (delegate && [delegate respondsToSelector:@selector(webPageLoad:responseString:)]) {
        [delegate performSelector:@selector(webPageLoad:responseString:) 
                       withObject:theRequest 
                       withObject:pageContent];
    }else {
        NSLog(@"代理不响应webPageLoad:responseString:方法");
    }
}

-(void) callActionLoad:(ASIFormDataRequest *) request withDataSet:(NSMutableArray *) dataSet
{
    if (delegate && [delegate respondsToSelector:@selector(actionLoad:)]) {
        [delegate performSelector:@selector(actionLoad:)
                       withObject:dataSet];
    }else {
        NSLog(@"代理不响应actionLoad:方法");
    }
}

-(void) callExecActionSuccess:(ASIHTTPRequest *) request withDataSet:(NSMutableArray *) dataSet
{
    
    if (delegate && [delegate respondsToSelector:@selector(execActionSuccess:)]) {
        [delegate performSelector:@selector(execActionSuccess:)
                       withObject:dataSet];
    }else {
        NSLog(@"代理不响应execActionSuccess:方法");
    }
}

-(void) callExecActionFailed:(ASIHTTPRequest *) request withErrorMessage:(NSString *) errorMessage
{
    //错误的消息
    //TODO:错误消息内容是什么
    if (delegate && [delegate respondsToSelector:@selector(execActionFailed:)]) {
        [delegate performSelector:@selector(execActionFailed:)
                       withObject:errorMessage];
    }else {
        NSLog(@"代理不响应execActionFailed:方法");
    }
}

@end
