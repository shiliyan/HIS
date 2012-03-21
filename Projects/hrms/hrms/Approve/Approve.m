//
//  Approve.m
//  Approve
//
//  Created by mas apple on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Approve.h"

@implementation Approve

@synthesize workflowId;
@synthesize recordId;
@synthesize workflowName;
@synthesize workflowDesc;
@synthesize nodeName;
@synthesize employeeName;
@synthesize creationDate;
@synthesize dateLimit;
@synthesize isLate;
@synthesize localStatus;
@synthesize comment;
@synthesize approveActionType;

-(void)dealloc{
    [workflowName release];
    [workflowDesc release];
    [nodeName release];
    [employeeName release];
    [creationDate release];
    [dateLimit release];
    [isLate release];
    [localStatus release];
    [comment release];
    [approveActionType release];
    
    [super dealloc];
}

-(Approve *)initWithWorkflowId:(NSInteger)wid workflowName:(NSString *)wName currentStatus:(NSString *)cStatus applicant:(NSString *)a deadLine:(NSString *)dLine commitDate:(NSString *)cDate todoType:(NSString *)tType{
    
    if (self = [super init]){
        self.workflowId = wid;
        self.workflowName = wName;
        self.nodeName = cStatus;
        self.employeeName = a;
        self.dateLimit = dLine;
        self.creationDate = cDate;
        self.isLate = tType;
    }
    
    return self;
}

-(Approve *)initWithDictionary:(NSMutableDictionary *)dic{
    if (self = [super init]){
        
        self.workflowId = [[dic objectForKey:APPROVE_PROPERTY_WORKFLOW_ID] integerValue];
        self.recordId = [[dic objectForKey:APPROVE_PROPERTY_RECORD_ID] integerValue];
        self.workflowName = [dic objectForKey:APPROVE_PROPERTY_WORKFLOW_NAME];
        self.workflowDesc = [dic objectForKey:APPROVE_PROPERTY_WORKFLOW_DESC];
        self.nodeName = [dic objectForKey:APPROVE_PROPERTY_NODE_NAME];
        self.employeeName = [dic objectForKey:APPROVE_PROPERTY_EMPLOYEE_NAME];
        self.creationDate = [dic objectForKey:APPROVE_PROPERTY_CREATION_DATE];
        self.dateLimit = [dic objectForKey:APPROVE_PROPERTY_DATE_LIMIT];
        self.isLate = [dic objectForKey:APPROVE_PROPERTY_IS_LATE];
        self.localStatus = [dic objectForKey:APPROVE_PROPERTY_LOCAL_STATUS];
        self.comment = [dic objectForKey:APPROVE_PROPERTY_COMMENT];
        self.approveActionType = [dic objectForKey:APPROVE_PROPERTY_APPROVE_ACTION_TYPE];
    }
    
    return self;
}

@end
