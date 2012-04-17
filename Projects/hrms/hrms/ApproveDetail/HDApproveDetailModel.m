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
@synthesize detailApprove = _detailApprove;
@synthesize dbHelper = _dbHelper;

//明细协议
@synthesize delegate;

-(id)initWithApprove:(Approve *)theApprove
{
    self = [super init];
    if (self) {
        self.detailApprove = theApprove;
    }
    return self;
}

-(void)dealloc
{    
    [_actionsRequest clearDelegatesAndCancel];
    [_webPageRequest clearDelegatesAndCancel];
    TT_RELEASE_SAFELY(_actionsRequest);
    TT_RELEASE_SAFELY(_webPageRequest);
    TT_RELEASE_SAFELY(_detailApprove);
    TT_RELEASE_SAFELY(_dbHelper);
    [super dealloc];
}

-(void)loadWebPage{
    //创建页面载入请求
    NSString * screenUrl = [NSString stringWithFormat:@"%@%@?record_id=%i",[HDURLCenter requestURLWithKey:@"APPROVE_SCREEN_BASE_PATH"],[_detailApprove screenName],[_detailApprove recordId]];    
    self.webPageRequest = [[HDHTTPRequestCenter shareHTTPRequestCenter] requestWithURL:screenUrl requestType:ASIRequestTypeWebPage forKey:nil];
    
	[_webPageRequest setDidFailSelector:@selector(webPageLoadFailed:)];
	[_webPageRequest setDidFinishSelector:@selector(webPageLoadSucceeded:)];
	[_webPageRequest setDelegate:self];
	[_webPageRequest setDownloadProgressDelegate:self];
    [_webPageRequest startAsynchronous];
    
}

-(void)loadWebActions{
    //    NSLog(@"HDAppreoveDetailModel -68 \n\n%@",self.recordID);
    NSDictionary * data = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:_detailApprove.recordId] forKey:@"record_id"];
    //////////////////////////////////////
    self.actionsRequest = [HDFormDataRequest hdRequestWithURL:[HDURLCenter requestURLWithKey:@"TOOLBAR_ACTION_QUERY_PATH"] 
                                                     withData:data
                                                      pattern:HDrequestPatternNormal];
    
    [_actionsRequest setSuccessSelector: @selector(actionLoadSucceeded:withDataSet:)];
    [_actionsRequest setDelegate:self];
    [_actionsRequest startAsynchronous];
}

-(void)loadCancel{
    [_webPageRequest clearDelegatesAndCancel];
    [_actionsRequest clearDelegatesAndCancel];
}

-(void)setActionID:(NSString *) theActionID
{
    _detailApprove.action= theActionID;
}

-(void)setComment:(NSString *) theComment
{
    _detailApprove.comment = theComment;
}

-(void)execAction
{
    [self configRequest];
    [self modifyRecordAction];
}

//配置请求
-(void) configRequest
{
    NSDictionary * actionData = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt: _detailApprove.recordId],@"record_id", _detailApprove.action,@"action_id", [_detailApprove comment],@"comment", nil];
    
    HDRequestConfigMap * map = [[HDHTTPRequestCenter shareHTTPRequestCenter] requestConfigMap];
    HDRequestConfig * execActionRequestConfig  = [map configForKey:@"detial_ready_post"];
    [execActionRequestConfig setRequestURL:[HDURLCenter requestURLWithKey:@"EXEC_ACTION_UPDATE_PATH"]];
    [execActionRequestConfig setRequestData:actionData];
    [execActionRequestConfig setTag:[_detailApprove rowId]];
}

//修改数据库记录状态 
-(void) modifyRecordAction
{
    ApproveDatabaseHelper * dbHelper = [[ApproveDatabaseHelper alloc]init];
    [dbHelper.db open];
    
    NSString *sql = [NSString stringWithFormat:@"update %@ set %@ = '%@',%@ = '%@' ,%@ = '%@' ,%@ = '%@' where rowId = %i",TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_LOCAL_STATUS,@"WAITING",APPROVE_PROPERTY_APPROVE_ACTION,_detailApprove.action,APPROVE_PROPERTY_SUBMIT_URL,[HDURLCenter requestURLWithKey:@"EXEC_ACTION_UPDATE_PATH"],APPROVE_PROPERTY_COMMENT,_detailApprove.comment,_detailApprove.rowId];
    
    //    NSLog(@"%@",sql);
    [dbHelper.db executeUpdate:sql];
    [dbHelper.db close];
    TT_RELEASE_SAFELY(dbHelper);
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

- (void)actionLoadSucceeded:(ASIFormDataRequest *)theRequest withDataSet:(NSArray *) dataSet
{
    //写数据库
    [self saveRecordActions:dataSet];
    //调用成功
    [self callActionLoad:theRequest withDataSet:dataSet];
}

-(void) callActionLoad:(ASIFormDataRequest *) theRequest withDataSet:(NSArray *) dataSet
{
    if (delegate && [delegate respondsToSelector:@selector(actionLoad:)]) {
        [delegate performSelector:@selector(actionLoad:)
                       withObject:dataSet];
    }else {
        NSLog(@"代理不响应actionLoad:方法");
    }
}

//保存审批动作
-(void)saveRecordActions:(NSArray *) dataSet
{
    ApproveDatabaseHelper * dbHelper = [[ApproveDatabaseHelper alloc]init];
    [dbHelper.db open];
    [dbHelper.db beginTransaction];
    
    NSString * deleteActionsSql = [NSString stringWithFormat:@"delete from %@ where record_id = %i;",TABLE_NAME_APPROVE_ACTION_LIST,_detailApprove.recordId];
    [dbHelper.db executeUpdate:deleteActionsSql];
    NSLog(@"%@",deleteActionsSql);
    
    for (NSDictionary * actionRecord in dataSet) 
    {
        NSString * insertActionsSql = [NSString stringWithFormat:@"insert into %@ (record_id,action_id,action_title) values('%i','%@','%@');",TABLE_NAME_APPROVE_ACTION_LIST,_detailApprove.recordId,[actionRecord valueForKey:@"action_id"],[actionRecord valueForKey:@"action_title"]];
        
        [dbHelper.db executeUpdate:insertActionsSql];
        NSLog(@"%@",insertActionsSql);
    }
    [dbHelper.db commit];
    [dbHelper.db close];
    TT_RELEASE_SAFELY(dbHelper);
}

-(void) removeRecordActions:(NSUInteger) theRecordID
{
    ApproveDatabaseHelper * dbHelper = [[ApproveDatabaseHelper alloc]init];
    [dbHelper.db open];
    [dbHelper.db beginTransaction];
    
    NSString * removeActionsSql = [NSString stringWithFormat:@"delete from %@ where record_id = %i;",TABLE_NAME_APPROVE_ACTION_LIST,theRecordID];
    [dbHelper.db executeUpdate:removeActionsSql];
    
    NSLog(@"%@",removeActionsSql);

}

@end
