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

static NSString * kApproveDetailWebPagePath = @"APPROVE_DETIAL_WEB_PAGE_PATH";

@implementation HDApproveModule

@synthesize approveEntity = _approveEntity;

+(id) approveModuleWithApprove:(Approve *) approve
{
    return [[[HDApproveModule alloc]initWithApprove:approve]autorelease];
}

-(id) initWithApprove:(Approve *) approve
{
    
    
    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
                           approve.docPageUrl,APPROVE_PROPERTY_SCREEN_NAME,
                           [NSString stringWithFormat:@"%@",approve.instanceId],APPROVE_PROPERTY_INSTANCE_ID,
                           [NSString stringWithFormat:@"%@",approve.recordID],APPROVE_PROPERTY_RECORD_ID,
                           nil];
    
    NSString * webPageURL = [HDURLCenter requestURLWithKey:kApproveDetailWebPagePath query:query];
    
    self = [super initWithWebPageURL:webPageURL];
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

//动作加载的代理方法
//指定加载动作的参数
-(id)actionsLoadParameterWithType:(NSString *)loadType
{
    return [NSDictionary dictionaryWithObject:[_approveEntity recordID] 
                                       forKey:@"record_id"];
}

//指定动作加载的路径
-(NSString *)actionsLoadPathWithType:(NSString *)loadType
{
    return [HDURLCenter requestURLWithKey:@"TOOLBAR_ACTION_QUERY_PATH"];
}


-(void)startLoad
{
    //如果记录状态是等待,不加载动作  
    if (![_approveEntity.localStatus isEqualToString:@"WAITING"]&&
        ![_approveEntity.localStatus isEqualToString:@"DIFFERENT"]) {
        [self startLoadAction];
    }
    [self startLoadWebPage];
}

//审批
-(void)saveApprove
{
    _approveEntity.submitUrl = [HDURLCenter requestURLWithKey:@"EXEC_ACTION_UPDATE_PATH"];
    [self configRequest];
    [self updateApproveRecord];
}

//配置请求
-(void) configRequest
{
    id approveObject =[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:_approveEntity.recordID,APPROVE_PROPERTY_RECORD_ID, _approveEntity.action,@"action_id", _approveEntity.comment,APPROVE_PROPERTY_COMMENT,nil],nil];
    
    HDRequestConfigMap * map = [[HDHTTPRequestCenter shareHTTPRequestCenter] requestConfigMap];
    HDRequestConfig * execActionRequestConfig  = [map configForKey:@"detial_ready_post"];
    [execActionRequestConfig setRequestURL:_approveEntity.submitUrl];
    [execActionRequestConfig setRequestData:approveObject];
    [execActionRequestConfig setTag:_approveEntity.rowID.integerValue];
}

//修改数据库记录状态 
-(void) updateApproveRecord
{
    ApproveDatabaseHelper * dbHelper = [[ApproveDatabaseHelper alloc]init];
    [dbHelper.db open];
    
    NSString *sql = [NSString stringWithFormat:@"update approve_list set local_status = '%@',action = '%@' ,submit_url = '%@' ,comment = '%@' where rowid = %@",
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
