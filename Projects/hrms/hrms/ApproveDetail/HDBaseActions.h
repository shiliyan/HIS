//
//  HDBaseActions.h
//  hrms
//
//  Created by Rocky Lee on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDURLCenter.h"

@interface HDBaseActions : NSObject

@property (nonatomic,assign) id delegate;
@property (nonatomic,retain) id actionsObject;
@property (nonatomic,assign) SEL didLoadSelector;
@property (nonatomic,retain) id actionsInfo;
@property (nonatomic,retain) HDFormDataRequest * actionsLoadRequest;
@property (nonatomic,copy) NSString * actionLoadURL;

+(id)actionsModule;

-(void)loadTheActions;

//从远程加载动作
-(void)loadTheRemoteActions;

//too dangerous
//-(void)beforeLoadTheRemoteActions:(HDBaseActions *) actionModule;

// 从本地数据库/文件等等加载动作,默认先从本地加载,返回NO则从远程加载
// 可以通过重写 loadTheActions 改变加载顺序
-(BOOL) loadTheLocalActions:(id) actionsInfo;

//调用加载完成回调,通知注册的delegate对象加载完成,返回 actionsObject
-(void)callDidLoadSelector;

//取消加载,默认取消远程加载的网络请求
-(void)cancelLoadingActions;

//保存动作
-(void)saveTheActions;

//根据参数删除动作
-(void)removeTheActions;

@end