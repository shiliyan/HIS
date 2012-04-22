//
//  HDBaseApprove.h
//  hrms
//
//  Created by Rocky Lee on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDApproveActions.h"
#import "ASIWebPageRequest.h"

@protocol HDApproveDetailDelegate;

@interface HDBaseApproveModule : NSObject<HDActionsDelegate>

@property (nonatomic,assign) id <HDApproveDetailDelegate> delegate;
@property (nonatomic,retain) HDApproveActions * actions;
@property (nonatomic,copy) NSString * webPageURL;
@property (nonatomic,retain) ASIWebPageRequest * webPageRequest;

-(id)initWithWebPageURL:(NSString *) theURL;

//加载开始
-(void)startLoad;

-(void)startLoadWebPage;
-(void)startLoadAction;

//取消加载
-(void)loadCancel;

//调用响应的delegate函数
-(void)callActionDidLoad:(id) actionsObject;

//将动作对象转换为数组,默认为直接返回actionObject,如果actionObject不是数组,重载该方法 
-(NSArray *) transformToActionArray:(id) actionsObject; 

//web请求前配置
-(void)beforeLoadWebPage:(ASIWebPageRequest *) webPageRequest;

-(void)callWebPageDidLoad:(NSString *)pageContent baseURL:(NSURL *)theBaseURL;

//审批
-(void)submitApprove;
@end

@protocol HDApproveDetailDelegate <NSObject>

@required
//网页加载完成回调
-(void) webPageDidLoad:(NSString *)htmlString baseURL:(NSURL *)theBaseURL;

//审批动作完成回调
-(void) actionDidLoad:(NSArray *) actionArray;
@end
