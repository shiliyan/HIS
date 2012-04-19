//
//  Approve.m
//  Approve
//
//  Created by mas apple on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Approve.h"

@implementation Approve

@synthesize rowID;
@synthesize workflowID;
@synthesize recordID;
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
@synthesize action;
@synthesize serverMessage;
@synthesize submitUrl;

-(void)dealloc{
    
    [rowID release];
    [ workflowID release];
    [ recordID release];
    [ workflowName release];
    [ workflowDesc release];
    [ nodeName release];
    [ employeeName release];
    [ creationDate release];
    [ dateLimit release];
    [ isLate release];
    [ screenName release];
    [ localStatus release];
    [ comment release];
    [ action release];
    [ serverMessage release];
    [ submitUrl release];
    [super dealloc];
}



-(Approve *)initWithRowId:(NSNumber *)rowid workflowId:(NSNumber *)wid recordId:(NSNumber *)rId workflowName:(NSString *)wName workflowDesc:(NSString *)wDesc nodeName:(NSString *)node employeeName:(NSString *)employee creationDate:(NSString *)creation dateLimit:(NSString *)limit  isLate:(NSNumber *)late screenName:(NSString *)screen localStatus:(NSString *)status comment:(NSString *)cmt actionType:(NSString *)aType serverMessage:(NSString *)sMessage submitUrl:(NSString *)url{
    
    if (self = [super init]){
        self.rowID = rowid;
        self.workflowID = wid;
        self.recordID = rId;
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
        self.action = aType;
        self.serverMessage = sMessage;
        self.submitUrl = url;
    }
    
    return self;
}

-(Approve *)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]){
        self.workflowID = [dic objectForKey:APPROVE_PROPERTY_WORKFLOW_ID];
        self.recordID = [dic objectForKey:APPROVE_PROPERTY_RECORD_ID];
        self.workflowName = [dic objectForKey:APPROVE_PROPERTY_WORKFLOW_NAME];
        self.workflowDesc = [dic objectForKey:APPROVE_PROPERTY_WORKFLOW_DESC];
        self.nodeName = [dic objectForKey:APPROVE_PROPERTY_NODE_NAME];
        self.employeeName = [dic objectForKey:APPROVE_PROPERTY_EMPLOYEE_NAME];
        self.creationDate = [dic objectForKey:APPROVE_PROPERTY_CREATION_DATE];
        self.dateLimit = [dic objectForKey:APPROVE_PROPERTY_DATE_LIMIT];
        self.isLate = [dic objectForKey:APPROVE_PROPERTY_IS_LATE];
        self.screenName = [dic objectForKey:APPROVE_PROPERTY_SCREEN_NAME];
        self.localStatus = [dic objectForKey:APPROVE_PROPERTY_LOCAL_STATUS];
        self.comment = [dic objectForKey:APPROVE_PROPERTY_COMMENT];
        self.action = [dic objectForKey:APPROVE_PROPERTY_APPROVE_ACTION];
        self.serverMessage = [dic objectForKey:APPROVE_PROPERTY_SERVER_MESSAGE];
        self.submitUrl = [dic objectForKey:APPROVE_PROPERTY_SUBMIT_URL];
    }
    return self;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"%@ recordId:%i rowid:%i",[super description],self.recordID.init,self.rowID.init];
}

@end
