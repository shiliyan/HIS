//
//  HDApproveActions.m
//  hrms
//
//  Created by Rocky Lee on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDApproveActions.h"
#import "ApproveDatabaseHelper.h"
#import "HDHTTPRequestCenter.h"

@implementation HDApproveActions

@synthesize actionsLoadRequest = _actionsLoadRequest;

+(id)actionsModule
{
    return [[[self alloc]init]autorelease];
}

-(void)dealloc
{
    [self cancelLoadingActions];
    TT_RELEASE_SAFELY(_actionsLoadRequest);
    [super dealloc];
}

-(void)cancelLoadingActions
{
    [_actionsLoadRequest clearDelegatesAndCancel];
}

//加载远程动作
-(void)loadTheRemoteActions
{
    //    TTDPRINT(@"%@",[self configActionsLoadPathWithType:HDActionLoadTypeRemote] );
    self.actionsLoadRequest = 
    [[HDHTTPRequestCenter shareHTTPRequestCenter]
                               requestWithURL:[self configActionsLoadPathWithType:HDActionLoadTypeRemote]
                               withData:[self configActionsLoadParameterWithType:HDActionLoadTypeRemote]
                               requestType:HDRequestTypeFormData forKey:nil];
    
//    [HDFormDataRequest hdRequestWithURL:[self configActionsLoadPathWithType:HDActionLoadTypeRemote] 
//                               withData:[self configActionsLoadParameterWithType:HDActionLoadTypeRemote]
//                                pattern:HDrequestPatternNormal];
    
    [_actionsLoadRequest setSuccessSelector: @selector(remoteActionLoadSucceeded:withDataSet:)];
    [_actionsLoadRequest setDelegate:self];
    [_actionsLoadRequest startAsynchronous];
}

//远程动作加载成功
-(void)remoteActionLoadSucceeded:(ASIFormDataRequest *)theRequest withDataSet:(NSArray *) dataSet
{
    //尝试保存动作到本地,由子类实现其方法
    //    TTDPRINT(@"%@",dataSet);
    [self saveTheActions:dataSet];
    [self callDidLoadSelector:@selector(actionsDidLoad:) 
                   withObject:dataSet];
}

-(id)loadTheLocalDataBaseActions
{
    NSNumber * recordID = [[self configActionsLoadParameterWithType:HDActionLoadTypeLocalDatabase] objectForKey:@"record_id"];
    ApproveDatabaseHelper * dbHelper = [[ApproveDatabaseHelper alloc]init];
    [dbHelper.db open];
    
    NSString * actionSelectSql = [NSString stringWithFormat:@"select record_id,action_id,action_title from action_list where record_id = %@ order by action_id;",recordID];
    
    FMResultSet *resultSet = [dbHelper.db executeQuery:actionSelectSql];
    NSMutableArray * actions = [NSMutableArray array];
    
    while ([resultSet next]) {
        [actions addObject:[resultSet resultDict]];
    }
    [resultSet close];
    [dbHelper.db close];
    
    TT_RELEASE_SAFELY(dbHelper);
    if ([actions count] == 0) {
        return nil;
    }
    return actions;
}

//保存审批动作
-(void)saveTheActions:(NSArray *)actionsObject
{
    [self removeTheActions:actionsObject];
    ApproveDatabaseHelper * dbHelper = [[ApproveDatabaseHelper alloc]init];
    [dbHelper.db open];
    [dbHelper.db beginTransaction]; 
    for (NSDictionary * actionRecord in actionsObject) 
    {
        NSString * insertActionsSql = [NSString stringWithFormat:@"insert into %@ (record_id,action_id,action_title) values(%@,%@,'%@');",TABLE_NAME_APPROVE_ACTION_LIST,
                                       [actionRecord valueForKey:@"record_id"],
                                       [actionRecord valueForKey:@"action_id"],
                                       [actionRecord valueForKey:@"action_title"]];
        
        [dbHelper.db executeUpdate:insertActionsSql];
        NSLog(@"%@",insertActionsSql);
    }
    [dbHelper.db commit];
    [dbHelper.db close];
    TT_RELEASE_SAFELY(dbHelper);
}

-(void)removeTheActions:(NSArray *) actionsObject
{
    if (nil != actionsObject && 0 < [actionsObject count]) {
        //获取第一条记录
        NSNumber * recordID = [[actionsObject objectAtIndex:0] objectForKey:@"record_id"];
        
        ApproveDatabaseHelper * dbHelper = [[ApproveDatabaseHelper alloc]init];
        [dbHelper.db open];
        [dbHelper.db beginTransaction];
        NSString * deleteActionsSql = [NSString stringWithFormat:@"delete from %@ where record_id = %@;",TABLE_NAME_APPROVE_ACTION_LIST,recordID];
        [dbHelper.db executeUpdate:deleteActionsSql];
        //        NSLog(@"%@",deleteActionsSql);
        [dbHelper.db commit];
        [dbHelper.db close];
        TT_RELEASE_SAFELY(dbHelper);
    }
}

@end
