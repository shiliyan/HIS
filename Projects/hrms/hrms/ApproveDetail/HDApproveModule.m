//
//  HDApproveDetail.m
//  hrms
//
//  Created by Rocky Lee on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDApproveModule.h"
#import "HDURLCenter.h"
#import "HDHTTPRequestCenter.h"
#import "HDURLCenter.h"
#import "ApproveDatabaseHelper.h"

@implementation HDApproveModule

@synthesize approveEntity = _approveEntity;

-(id) initWithApproveModule:(Approve *) approve
{
    self = [super init];
    if (self) {
        self.approveEntity = approve;
        NSString * screenUrl = [NSString stringWithFormat:@"%@%@?record_id=%@",[HDURLCenter requestURLWithKey:@"APPROVE_SCREEN_BASE_PATH"],[_approveEntity screenName],[_approveEntity recordID]];  
        NSLog(@"%@",screenUrl);
        self.webPageURL = screenUrl;
    }
    return self;
}

-(void)beforeLoadActions:(HDBaseActions *)actionModule
{
    NSDictionary * parameter = [NSDictionary dictionaryWithObject:[_approveEntity recordID] 
                                                           forKey:@"record_id"];
    [actionModule setActionLoadParameters:parameter];
}

//-(void)startLoad
//{
//    //如果记录状态是等待,不加载动作    
//}

//审批
-(void)approve
{
    //TODO:如果只是单纯的保存数据库,然后发送消息?
    [self configRequest];
    [self modifyRecordAction];
}

//配置请求
-(void) configRequest
{
    NSDictionary * approveObject = [NSDictionary dictionaryWithObjectsAndKeys:_approveEntity.recordID,@"record_id", _approveEntity.action,@"action_id", _approveEntity.comment,@"comment", nil];
    
    HDRequestConfigMap * map = [[HDHTTPRequestCenter shareHTTPRequestCenter] requestConfigMap];
    HDRequestConfig * execActionRequestConfig  = [map configForKey:@"detial_ready_post"];
    [execActionRequestConfig setRequestURL:[HDURLCenter requestURLWithKey:@"EXEC_ACTION_UPDATE_PATH"]];
    [execActionRequestConfig setRequestData:approveObject];
    [execActionRequestConfig setTag:_approveEntity.rowID.integerValue];
}

//修改数据库记录状态 
-(void) modifyRecordAction
{
    ApproveDatabaseHelper * dbHelper = [[ApproveDatabaseHelper alloc]init];
    [dbHelper.db open];
    
    NSString *sql = [NSString stringWithFormat:@"update %@ set %@ = '%@',%@ = '%@' ,%@ = '%@' ,%@ = '%@' where rowId = %i",TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_LOCAL_STATUS,@"WAITING",APPROVE_PROPERTY_APPROVE_ACTION,_approveEntity.action,APPROVE_PROPERTY_SUBMIT_URL,[HDURLCenter requestURLWithKey:@"EXEC_ACTION_UPDATE_PATH"],APPROVE_PROPERTY_COMMENT,_approveEntity.comment,_approveEntity.rowID];
    
    //    NSLog(@"%@",sql);
    [dbHelper.db executeUpdate:sql];
    [dbHelper.db close];
    TT_RELEASE_SAFELY(dbHelper);
}

@end
