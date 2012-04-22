//
//  HDBaseActions.h
//  hrms
//
//  Created by Rocky Lee on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDURLCenter.h"

static NSString * HDActionLoadTypeRemote = @"REMOTE";
static NSString * HDActionLoadTypeLocalDatabase = @"LOCAL_DATABASE";
static NSString * HDActionLoadTypeLocalFile = @"LOCAL_FILE";


@protocol HDActionsDelegate;

@interface HDBaseActions : NSObject

@property (nonatomic,assign) id <HDActionsDelegate> delegate;

+(id)actionsModule;

-(void)loadTheActions;

// 从本地数据库/文件等等加载动作,默认先从本地加载,返回NO则从远程加载,具体的调用可以委托给下面两个方法,这里设定加载动作,文件和数据库有优先级逻辑
// 可以通过重写 loadTheActions 改变加载顺序
-(id)loadTheLocalActions;

//加载本地数据库保存的动作
-(id)loadTheLocalDataBaseActions;
//加载本地文件保存的动作
-(id)loadTheLocalFileActions;

//从远程加载动作
-(void)loadTheRemoteActions;

//取消加载动作
-(void)cancelLoadingActions;

//保存动作
-(void)saveTheActions:(id) actionObject;

//根据参数删除动作
-(void)removeTheActions:(NSArray *) actionsObject;

//动作加载参数调用delegate方法,默认返回nil
-(id) configActionsLoadParameterWithType:(NSString *) loadType;

//动作加载路径调用delegate方法,默认返回nil
-(NSString *)configActionsLoadPathWithType:(NSString *) loadType;

//调用加载完成回调,通知注册的delegate对象加载完成,返回 actionsObject
-(void)callDidLoadSelector:(SEL)selector withObject:(id) actionsObject;

@end

@protocol HDActionsDelegate <NSObject>
@required
//动作加载的路径,根据这个路径获取动作,可以是一个url或者本地文件路径或者数据库地址
-(NSString *) actionsLoadPathWithType:(NSString *) loadType;

@optional
//设置动作加载条件参数,根据这个参数加载指定的动作
-(id) actionsLoadParameterWithType:(NSString *) loadType;

-(void) actionsDidLoad:(NSArray *) actionsObject;
@end