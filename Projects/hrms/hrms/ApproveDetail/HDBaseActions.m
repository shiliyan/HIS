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

+(id)actionsModule
{
    return [[[self alloc]init]autorelease];
}

//配置动作加载路径
-(NSString *)configActionsLoadPathWithType:(NSString *) loadType
{
    if (delegate && [delegate respondsToSelector:@selector(actionsLoadPathWithType:)]) {
        return [delegate performSelector:@selector(actionsLoadPathWithType:) withObject:loadType];
    }
    return nil;
}

//配置动作加载条件参数
-(id) configActionsLoadParameterWithType:(NSString *) loadType
{
    if (delegate && [delegate respondsToSelector:@selector(actionsLoadParameterWithType:)]) {
        return [delegate performSelector:@selector(actionsLoadParameterWithType:) withObject:loadType];
    }
    return nil;
}

//加载动作,如果本地加载返回nil则从远程加载,重载这个函数改变加载策略(本地还是远程)
-(void)loadTheActions
{
    if (nil != [self loadTheLocalActions]) {
        [self callDidLoadSelector:@selector(actionsDidLoad:) withObject:[self loadTheLocalActions]];
    }else {
        [self loadTheRemoteActions];
    }
}

//加载本地动作,如果默认返回nil,从远程加载,重载这个函数改变加载策略(本地数据库/文件)
-(id)loadTheLocalActions
{
    if (nil != [self loadTheLocalDataBaseActions]) {
        return [self loadTheLocalDataBaseActions];
    }else {
        return [self loadTheLocalFileActions];
    }
}

-(id)loadTheLocalDataBaseActions
{
    return nil;
}

-(id)loadTheLocalFileActions
{
    return nil;
}

-(void)loadTheRemoteActions{}

-(void)cancelLoadingActions{}

//调用代理方法,通知代理对象加载完成 
-(void)callDidLoadSelector:(SEL)selector withObject:(NSArray *) actionsObject
{
    if (nil == actionsObject || [actionsObject count] == 0) {
        return ;
    }
    if (delegate && [delegate respondsToSelector:selector]) {
        [delegate performSelector:selector
                       withObject:actionsObject];   
    }else {
        NSLog(@"代理不响应webPageLoad:responseString:方法");
    }
}

-(void)saveTheActions:(NSArray *) actionObject{}

-(void)removeTheActions:(NSArray *) actionsObject{}

@end

