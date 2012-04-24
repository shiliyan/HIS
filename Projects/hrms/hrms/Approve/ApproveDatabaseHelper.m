//
//  ApproveDatabaseHelper.m
//  hrms
//
//  Created by mas apple on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ApproveDatabaseHelper.h"

@implementation ApproveDatabaseHelper

@synthesize db;

-(void)initTables{

    NSString *createTableSql =
    [NSString stringWithFormat:@"create table if not exists %@ (workflow_id integer,record_id integer,is_late text,screen_name text,workflow_name text,workflow_desc text,node_name text,employee_name text,creation_date text,date_limit text,local_status text,comment text,action text,server_message text, submit_url text)",TABLE_NAME_APPROVE_LIST];
    
    NSString * createActionTableSql = [NSString stringWithFormat:@"create table if not exists %@ (record_id integer, action_id integer,action_title text)",TABLE_NAME_APPROVE_ACTION_LIST];
    
    if (![db open]) {
        [db release];
        NSLog(@"Could not open db.");  
        return;
    }
    
    [db executeUpdate:createTableSql];
    [db executeUpdate:createActionTableSql];
    [db close];
}

-(id)init{
    self = [super init];
    
    if(self){
        //读入数据库
        //paths： ios下Document路径，Document为ios中可读写的文件夹  
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
        NSString *documentDirectory = [paths objectAtIndex:0];  
        //dbPath： 数据库路径，在Document中。  
        NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DB_NAME]; 
//        NSLog(@"%@",dbPath);
        //创建数据库实例 db  
        db= [[FMDatabase databaseWithPath:dbPath]retain]; 
        
        [self initTables];
    }
    
    return self; 
}

-(void)dealloc{
    [db release];
    [super dealloc];
}
    
@end