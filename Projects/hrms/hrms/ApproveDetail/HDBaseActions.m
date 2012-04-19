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
@synthesize actionLoadParameters = _actionLoadParameters;

+(id)actionsModule
{
    return [[[HDBaseActions alloc]init]autorelease];
}

-(void)loadActions
{
    //加载动作
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

-(void)cancelLoadingActions{}

-(void)saveActions{}

-(void)removeActions{}

@end

