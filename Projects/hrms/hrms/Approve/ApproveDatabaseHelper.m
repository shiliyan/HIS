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
    [NSString stringWithFormat:@"create table if not exists %@ (%@ integer,%@ text,%@ text,%@ text,%@ text,%@ text,%@ text)",TABLE_NAME_APPROVE_LIST,COLUMN_WORKFLOW_ID,COLUMN_WORKFLOW_NAME,COLUMN_CURRENT_STATUS,COLUMN_APPLICANT,COLUMN_COMMIT_DATE,COLUMN_DEADLINE,COLUMN_TYPE];
    
    if (![db open]) {  
        [db release];
        NSLog(@"Could not open db.");  
        return;
    }
    
    [db executeUpdate:createTableSql];
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
        NSLog(@"%@",dbPath);
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