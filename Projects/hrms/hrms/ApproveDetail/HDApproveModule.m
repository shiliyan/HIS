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

+(id) approveModuleWithApprove:(Approve *) approve
{
    return [[[HDApproveModule alloc]initWithApprove:approve]autorelease];
}

-(id) initWithApprove:(Approve *) approve
{
    NSString * screenUrl = [[[NSString alloc]initWithFormat:@"%@%@?record_id=%@",[HDURLCenter requestURLWithKey:@"APPROVE_SCREEN_BASE_PATH"],[approve screenName],[approve recordID]]autorelease];
    
    self = [super initWithWebPageURL:screenUrl];
    if (self) {
        self.approveEntity = approve;
    }
    return self;
}

-(void)dealloc
{
    TT_RELEASE_SAFELY(_approveEntity);
    [super dealloc];
}

-(id)actionsLoadParameterWithType:(NSString *)loadType
{
    return [NSDictionary dictionaryWithObject:[_approveEntity recordID] 
                                       forKey:@"record_id"];
}

-(NSString *)actionsLoadPathWithType:(NSString *)loadType
{
    return [HDURLCenter requestURLWithKey:@"TOOLBAR_ACTION_QUERY_PATH"];
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
