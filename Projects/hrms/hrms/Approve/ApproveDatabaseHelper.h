//
//  ApproveDatabaseHelper.h
//  hrms
//
//  Created by mas apple on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *DB_NAME = @"Approve.db";
static NSString *TABLE_NAME_APPROVE_LIST = @"approve_list";

static NSString *COLUMN_WORKFLOW_ID = @"workflowId"; 
static NSString *COLUMN_WORKFLOW_NAME = @"workflowName"; 
static NSString *COLUMN_CURRENT_STATUS = @"currentStatus"; 
static NSString *COLUMN_APPLICANT = @"applicant"; 
static NSString *COLUMN_COMMIT_DATE = @"commitDate"; 
static NSString *COLUMN_DEADLINE = @"deadLine"; 
static NSString *COLUMN_TYPE = @"type"; 
 
@interface ApproveDatabaseHelper : NSObject{
    FMDatabase *db;
}

@property (readonly) FMDatabase *db;

-(void)initTables;
@end
