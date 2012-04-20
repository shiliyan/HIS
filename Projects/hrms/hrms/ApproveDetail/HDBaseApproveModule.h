//
//  HDBaseApprove.h
//  hrms
//
//  Created by Rocky Lee on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDBaseActions.h"
#import "ASIWebPageRequest.h"

@protocol HDApproveDetailDelegate;

@interface HDBaseApproveModule : NSObject

@property (nonatomic,assign) id <HDApproveDetailDelegate> delegate;
@property (nonatomic,retain) HDBaseActions * actions;
@property (nonatomic,copy) NSString * webPageURL;
@property (nonatomic,retain) ASIWebPageRequest * webPageRequest;
//加载开始
-(void)startLoad;

-(void)startLoadWebPage;
-(void)startLoadAction;

//取消加载
-(void)loadCancel;

//调用响应的delegate函数
-(void)callActionLoad:(id) actionsObject;

//动作加载开始前,配置加载参数
-(void)beforeLoadActions:(HDBaseActions *) actionModule;

//加载动作需要的参数
-(id)getActionsInfo;

-(NSArray *) transformToActionArray:(id) actionsObject; 

//web请求前配置
-(void)beforeLoadWebPage:(ASIWebPageRequest *) webPageRequest;

-(void)callWebPageLoad:(NSString *)pageContent baseURL:(NSURL *)theBaseURL;

//审批
-(void)submitApprove;
@end

@protocol HDApproveDetailDelegate <NSObject>

@required
//网页加载完成回调
-(void) webPageLoad:(NSString *)htmlString baseURL:(NSURL *)theBaseURL;

//审批动作完成回调
-(void) actionLoad:(NSArray *) actionArray;
@end
