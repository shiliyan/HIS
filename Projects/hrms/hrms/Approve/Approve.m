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
@synthesize nodeId;
@synthesize instanceId;
@synthesize orderType;
@synthesize instanceDesc;
@synthesize instanceParam;
@synthesize nodeName;
@synthesize employeeName;
@synthesize creationDate;
@synthesize dateLimit;
@synthesize isLate;
@synthesize docPageUrl;
@synthesize localStatus;
@synthesize comment;
@synthesize action;
@synthesize serverMessage;
@synthesize submitUrl;
@synthesize statusName;
@synthesize workflowName;

-(void)dealloc{
    
    [rowID release];
    [workflowID release];
    [recordID release];
    [orderType release];
    [instanceDesc release];
    [nodeName release];
    [employeeName release];
    [creationDate release];
    [dateLimit release];
    [isLate release];
    [docPageUrl release];
    [localStatus release];
    [comment release];
    [action release];
    [serverMessage release];
    [submitUrl release];
    [nodeId release];
    [instanceId release];
    [instanceParam release];
    [statusName release];
    [workflowName release];
    [super dealloc];
}



-(Approve *)initWithRowId:(NSNumber *)rowid 
               workflowId:(NSNumber *)wid 
                 recordId:(NSNumber *)rId
                   nodeId:(NSNumber *)nId 
               instanceId:(NSNumber *)insId 
                orderType:(NSString *)wName 
             instanceDesc:(NSString *)wDesc 
            instanceParam:(NSNumber *)insParam 
                 nodeName:(NSString *)node
             employeeName:(NSString *)employee 
             creationDate:(NSString *)creation 
                dateLimit:(NSString *)limit  
                   isLate:(NSNumber *)late
               screenName:(NSString *)screen 
              localStatus:(NSString *)status 
                  comment:(NSString *)cmt
               actionType:(NSString *)aType 
            serverMessage:(NSString *)sMessage
                submitUrl:(NSString *)url{
    
    if (self = [super init]){
        self.rowID = rowid;
        self.workflowID = wid;
        self.recordID = rId;
        self.orderType = wName;
        self.instanceDesc = wDesc;
        self.nodeName = node;
        self.employeeName = employee;
        self.creationDate = creation;
        self.dateLimit = limit;
        self.isLate = late;
        self.docPageUrl = screen;
        self.localStatus = status;
        self.comment = cmt;
        self.action = aType;
        self.serverMessage = sMessage;
        self.submitUrl = url;
        
        self.nodeId = nId;
        self.instanceId = insId;
        self.instanceParam = insParam;
    }
    
    return self;
}

-(Approve *)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]){
        self.workflowID = [dic objectForKey:APPROVE_PROPERTY_WORKFLOW_ID];
        self.recordID = [dic objectForKey:APPROVE_PROPERTY_RECORD_ID];
        self.orderType = [dic objectForKey:APPROVE_PROPERTY_ORDER_TYPE];
        self.instanceDesc = [dic objectForKey:APPROVE_PROPERTY_INSTANCE_DESC];
        self.nodeName = [dic objectForKey:APPROVE_PROPERTY_NODE_NAME];
        self.employeeName = [dic objectForKey:APPROVE_PROPERTY_EMPLOYEE_NAME];
        self.creationDate = [dic objectForKey:APPROVE_PROPERTY_CREATION_DATE];
        self.dateLimit = [dic objectForKey:APPROVE_PROPERTY_DATE_LIMIT];
        self.isLate = [dic objectForKey:APPROVE_PROPERTY_IS_LATE];
        self.docPageUrl = [dic objectForKey:APPROVE_PROPERTY_SCREEN_NAME];
        self.localStatus = [dic objectForKey:APPROVE_PROPERTY_LOCAL_STATUS];
        self.comment = [dic objectForKey:APPROVE_PROPERTY_COMMENT];
        self.action = [dic objectForKey:APPROVE_PROPERTY_APPROVE_ACTION];
        self.serverMessage = [dic objectForKey:APPROVE_PROPERTY_SERVER_MESSAGE];
        self.submitUrl = [dic objectForKey:APPROVE_PROPERTY_SUBMIT_URL];
        self.nodeId = [dic objectForKey:APPROVE_PROPERTY_NODE_ID];
        self.instanceId=[dic objectForKey:APPROVE_PROPERTY_INSTANCE_ID];
        self.instanceParam = [dic objectForKey:APPROVE_PROPERTY_INSTANCE_PARAM];
    }
    return self;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"%@ recordId:%i rowid:%i ,screenname:%@",[super description],self.recordID.init,self.rowID.init,self.docPageUrl];
}

@end
