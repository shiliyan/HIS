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
@synthesize workflowName;
@synthesize currentStatus;
@synthesize applicant;
@synthesize commitDate;
@synthesize deadLine;
@synthesize type;

-(void)dealloc{
    [workflowName release];
    [currentStatus release];
    [applicant release];
    [deadLine release];
    [commitDate release];
    [type release];
    [super dealloc];
}

-(Approve *)initWithWorkflowId:(int)wid workflowName:(NSString *)wName currentStatus:(NSString *)cStatus applicant:(NSString *)a deadLine:(NSString *)dLine commitDate:(NSString *)cDate todoType:(NSString *)tType{
    
    if (self = [super init]){
        self.workflowId = wid;
        self.workflowName = wName;
        self.currentStatus = cStatus;
        self.applicant = a;
        self.deadLine = dLine;
        self.commitDate = cDate;
        self.type = tType;
    }
    
    return self;
}

@end
