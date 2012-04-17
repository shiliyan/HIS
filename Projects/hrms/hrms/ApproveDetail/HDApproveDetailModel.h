//
//  HDApproveDetailModel.h
//  hrms
//
//  Created by Rocky Lee on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
// 加载审批动作
// 请求网页
// 修改审批记录  
// 保存审批动作
// ----删除审批动作
// ----

#import <Foundation/Foundation.h>
#import "HDApproveDetailDelegate.h"
#import "HDFormDataRequest.h"
#import "ASIWebPageRequest.h"
#import "ApproveDatabaseHelper.h"
#import "Approve.h"

@interface HDApproveDetailModel : NSObject
{
    id <HDApproveDetailDelegate> delegate;
}

//@property (nonatomic,retain) NSNumber * recordID;
//@property (nonatomic,retain) NSNumber * actionID;
//@property (nonatomic,retain) NSString * comment;
//@property (nonatomic,retain) NSString * screenName;

@property (nonatomic,retain) Approve * detailApprove;

@property (nonatomic,retain) HDFormDataRequest * actionsRequest;
@property (nonatomic,retain) ASIWebPageRequest * webPageRequest;

@property (nonatomic,assign) id <HDApproveDetailDelegate> delegate;

@property (nonatomic,retain) ApproveDatabaseHelper * dbHelper;

-(void)loadWebPage;
-(void)loadWebActions;
-(void)loadCancel;

-(void)execAction;
//-(void)execAction:(NSNumber *) theActionID;

//-(id)initWithRecordID:(NSNumber *) theRecordID 
//           screenName:(NSString *) theScreenName;
-(void)setActionID:(NSString *) theActionID;

-(void)setComment:(NSString *) theComment;

-(id)initWithApprove:(Approve *) theApprove;

-(void) removeRecordActions:(NSUInteger) theRecordID;

@end
