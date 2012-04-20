//
//  HDBaseActions.m
//  hrms
//
//  Created by Rocky Lee on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDBaseActions.h"

@implementation HDBaseActions

@synthesize delegate;
@synthesize actionsObject;
@synthesize didLoadSelector;
@synthesize actionsInfo = _actionsInfo;
@synthesize actionsLoadRequest = _actionsLoadRequest;
@synthesize actionLoadURL = _actionLoadURL;

+(id)actionsModule
{
    return [[[HDBaseActions alloc]init]autorelease];
}

-(void)dealloc
{
    [self cancelLoadingActions];
    TT_RELEASE_SAFELY(_actionsLoadRequest);
    TT_RELEASE_SAFELY(_actionLoadURL);
    [super dealloc];
}

-(void)loadTheActions
{
    //加载动作,默认从远程加载
    if ([self loadTheLocalActions:_actionsInfo]) {
        [self callDidLoadSelector];
    }else {
        [self loadTheRemoteActions];
    }
}

-(BOOL) loadTheLocalActions:(id) actionsInfo
{
    return NO;
}

-(void)loadTheRemoteActions
{
    self.actionsLoadRequest = [HDFormDataRequest hdRequestWithURL:_actionLoadURL 
                                                         withData:_actionsInfo
                                                          pattern:HDrequestPatternNormal];
    
    [_actionsLoadRequest setSuccessSelector: @selector(actionLoadSucceeded:withDataSet:)];
    [_actionsLoadRequest setDelegate:self];
    [self beforeLoadTheRemoteActions:self];
    [_actionsLoadRequest startAsynchronous];
}

-(void)beforeLoadTheRemoteActions:(HDBaseActions *) actionModule{}

- (void)actionLoadSucceeded:(ASIFormDataRequest *)theRequest withDataSet:(NSArray *) dataSet
{
    self.actionsObject = dataSet;
    [self saveTheActions];
    [self callDidLoadSelector];
}

-(void)callDidLoadSelector
{
    if (delegate && [delegate respondsToSelector:self.didLoadSelector]) {
        [delegate performSelector:self.didLoadSelector
                       withObject:self.actionsObject];
    }else {
        NSLog(@"代理不响应webPageLoad:responseString:方法");
    }
}

-(void)cancelLoadingActions
{
    [_actionsLoadRequest clearDelegatesAndCancel];
}

-(void)saveTheActions{}

-(void)removeTheActions{}

@end

