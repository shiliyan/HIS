//
//  HDApproveActions.m
//  hrms
//
//  Created by Rocky Lee on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDApproveActions.h"
#import "HDURLCenter.h"

@implementation HDApproveActions

@synthesize actionsRequest = _actionsRequest;

+(id)actionsModule
{
    return [[[HDApproveActions alloc]init]autorelease];
}

-(void)dealloc
{
    [_actionsRequest clearDelegatesAndCancel];
    TT_RELEASE_SAFELY(_actionsRequest)
    [super dealloc];
}

-(void)loadActions
{
    self.actionsRequest = [HDFormDataRequest hdRequestWithURL:[HDURLCenter requestURLWithKey:@"TOOLBAR_ACTION_QUERY_PATH"] 
                                                     withData:self.actionLoadParameters
                                                      pattern:HDrequestPatternNormal];
    
    [_actionsRequest setSuccessSelector: @selector(actionLoadSucceeded:withDataSet:)];
    [_actionsRequest setDelegate:self];
    [_actionsRequest startAsynchronous];
}

- (void)actionLoadSucceeded:(ASIFormDataRequest *)theRequest withDataSet:(NSArray *) dataSet
{
    self.actionsObject = dataSet;
    [self callDidLoadSelector];
}

@end
