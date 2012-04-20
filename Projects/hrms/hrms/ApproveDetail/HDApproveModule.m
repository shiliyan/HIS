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

-(id)getActionsInfo
{
    return [NSDictionary dictionaryWithObject:[_approveEntity recordID] 
                                       forKey:@"record_id"];
}

-(void)startLoad
{
    //如果记录状态是等待,不加载动作  
    if (![_approveEntity.localStatus isEqualToString:@"WAITING"]) {
        [self startLoadAction];
    }
    [self startLoadWebPage];
}

//审批
-(void)saveApprove
{
    _approveEntity.submitUrl = [HDURLCenter requestURLWithKey:@"EXEC_ACTION_UPDATE_PATH"];
    [self configRequest];
    [self updateRecordAction];
}

//配置请求
-(void) configRequest
{
    NSDictionary * approveObject = [NSDictionary dictionaryWithObjectsAndKeys:_approveEntity.recordID,@"record_id", _approveEntity.action,@"action_id", _approveEntity.comment,@"comment", nil];
    
    HDRequestConfigMap * map = [[HDHTTPRequestCenter shareHTTPRequestCenter] requestConfigMap];
    HDRequestConfig * execActionRequestConfig  = [map configForKey:@"detial_ready_post"];
    [execActionRequestConfig setRequestURL:_approveEntity.submitUrl];
    [execActionRequestConfig setRequestData:approveObject];
    [execActionRequestConfig setTag:_approveEntity.rowID.integerValue];
}

//修改数据库记录状态 
-(void) updateRecordAction
{
    ApproveDatabaseHelper * dbHelper = [[ApproveDatabaseHelper alloc]init];
    [dbHelper.db open];
    
    NSString *sql = [NSString stringWithFormat:@"update approve_list set local_status = '%@',action = '%@' ,submit_url = '%@' ,comment = '%@' where rowid = %i",
                     @"WAITING",
                     _approveEntity.action,
                     _approveEntity.submitUrl,
                     _approveEntity.comment,
                     _approveEntity.rowID];
    //    NSLog(@"%@",sql);
    [dbHelper.db executeUpdate:sql];
    [dbHelper.db close];
    TT_RELEASE_SAFELY(dbHelper);
}

@end
