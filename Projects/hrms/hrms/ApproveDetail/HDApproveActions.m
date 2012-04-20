//
//  HDApproveActions.m
//  hrms
//
//  Created by Rocky Lee on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDApproveActions.h"
#import "ApproveDatabaseHelper.h"

@implementation HDApproveActions

+(id)actionsModule
{
    return [[[HDApproveActions alloc]init]autorelease];
}

-(id)init
{
    self = [super init];
    if (self) {
        self.actionLoadURL = [HDURLCenter requestURLWithKey:@"TOOLBAR_ACTION_QUERY_PATH"];
    }
    return self;
}

-(BOOL) loadTheLocalActions:(id) actionsInfo
{
    NSNumber * recordID = [actionsInfo objectForKey:@"record_id"];
    NSLog(@"%@",recordID);
    ApproveDatabaseHelper * dbHelper = [[ApproveDatabaseHelper alloc]init];
    [dbHelper.db open];
    
    NSString * actionSelectSql = [NSString stringWithFormat:@"select record_id,action_id,action_title from action_list where record_id = %@ order by action_id;",recordID];
    
    FMResultSet *resultSet = [dbHelper.db executeQuery:actionSelectSql];
    NSMutableArray * actions = [[NSMutableArray alloc]init];
    while ([resultSet next]) {
        [actions addObject:[resultSet resultDict]];
    }
    self.actionsObject = actions; 
    [actions release];
    [dbHelper.db close];
    TT_RELEASE_SAFELY(dbHelper);
    //如果成功返回 YES
    //否则返回 NO
    if (0 < [actions count]) {
        return YES;
    }else {
        return NO;
    }
    return NO;
}

//保存审批动作
-(void)saveTheActions
{
    [self removeTheActions];
    ApproveDatabaseHelper * dbHelper = [[ApproveDatabaseHelper alloc]init];
    [dbHelper.db open];
    [dbHelper.db beginTransaction]; 
    for (NSDictionary * actionRecord in self.actionsObject) 
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

-(void)removeTheActions
{
    if (nil != self.actionsObject & 0 < [self.actionsObject count]) {
        //获取第一条记录
        NSNumber * recordID = [[self.actionsObject objectAtIndex:0] objectForKey:@"record_id"];
        
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
