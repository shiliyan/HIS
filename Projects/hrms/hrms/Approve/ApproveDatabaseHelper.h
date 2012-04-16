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
static NSString *TABLE_NAME_APPROVE_ACTION_LIST = @"action_list";

@interface ApproveDatabaseHelper : NSObject{
    FMDatabase *db;
}

@property (readonly) FMDatabase *db;

-(void)initTables;
@end
