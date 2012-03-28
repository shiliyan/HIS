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
@synthesize screenName;
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

    [localStatus release];
    [comment release];
    
    [super dealloc];
}

-(Approve *)initWithWorkflowId:(NSUInteger)wid workflowName:(NSString *)wName nodeName:(NSString *)cStatus employeeName:(NSString *)a limitDate:(NSString *)dLine creationDate:(NSString *)cDate lsLate:(NSUInteger)tType{
    return [self initWithWorkflowId:wid recordId:-1 workflowName:wName workflowDesc:nil nodeName:cStatus employeeName:a creationDate:cDate dateLimit:dLine isLate:tType screenName:nil  localStatus:nil comment:nil approveActionType:-1];
    
}

-(Approve *)initWithWorkflowId:(NSUInteger)wid workflowName:(NSString *)wName nodeName:(NSString *)node employeeName:(NSString *)employee dateLimit:(NSString *)limit creationDate:(NSString *)creation isLate:(NSUInteger)late comment:(NSString *)cmt{
    
    return [self initWithWorkflowId:wid recordId:-1 workflowName:wName workflowDesc:nil nodeName:node employeeName:employee creationDate:creation dateLimit:limit isLate:late screenName:nil localStatus:nil comment:cmt approveActionType:-1];
}

-(Approve *)initWithWorkflowId:(NSUInteger)wid recordId:(NSUInteger)rId workflowName:(NSString *)wName workflowDesc:(NSString *)wDesc nodeName:(NSString *)node employeeName:(NSString *)employee creationDate:(NSString *)creation dateLimit:(NSString *)limit  isLate:(NSUInteger)late screenName:(NSString *)screen localStatus:(NSString *)status comment:(NSString *)cmt approveActionType:(NSUInteger)actionType{
    
    if (self = [super init]){
        self.workflowId = wid;
        self.recordId = rId;
        self.workflowName = wName;
        self.workflowDesc = wDesc;
        self.nodeName = node;
        self.employeeName = employee;
        self.creationDate = creation;
        self.dateLimit = limit;
        self.isLate = late;
        self.screenName = screen;
        self.localStatus = status;
        self.comment = cmt;
        self.approveActionType = actionType;
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
        NSString *dl = [dic objectForKey:APPROVE_PROPERTY_DATE_LIMIT];
        self.dateLimit = (dl == nil ? @"" : dl);
        self.isLate = [[dic objectForKey:APPROVE_PROPERTY_IS_LATE]integerValue];
        self.screenName = [dic objectForKey:APPROVE_PROPERTY_SCREEN_NAME];
        self.localStatus = [dic objectForKey:APPROVE_PROPERTY_LOCAL_STATUS];
        self.comment = [dic objectForKey:APPROVE_PROPERTY_COMMENT];
        self.approveActionType = [[dic objectForKey:APPROVE_PROPERTY_APPROVE_ACTION_TYPE]intValue];
    }
    
    return self;
}

@end
