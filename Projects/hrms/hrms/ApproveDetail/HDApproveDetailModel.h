//
//  HDApproveDetailModel.h
//  hrms
//
//  Created by Rocky Lee on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDApproveDetailDelegate.h"
#import "HDFormDataRequest.h"
#import "ASIWebPageRequest.h"
#import "ASIDownloadCache.h"

static NSString * kBaseUrl = @"http://172.20.0.20:8080/hr_new/modules/ios/IOS_APPROVE/";
static NSString * kToolBarActionUrl = @"http://172.20.0.20:8080/hr_new/autocrud/ios.IOS_APPROVE.ios_workflow_approve_action_query/query";
static NSString * kDoActionUrl = @"http://172.20.0.20:8080/hr_new/autocrud/ios.IOS_APPROVE.ios_workflow_approve_action_submit/update";

@interface HDApproveDetailModel : NSObject
{
    id <HDApproveDetailDelegate> delegate;
}

@property (nonatomic,retain) NSNumber * recordID;
@property (nonatomic,retain) NSNumber * actionID;
@property (nonatomic,retain) NSString * comment;
@property (nonatomic,retain) NSString * screenName;

@property (nonatomic,retain) HDFormDataRequest * actionsRequest;
@property (nonatomic,retain) ASIWebPageRequest * webPageRequest;

@property (nonatomic,assign) id <HDApproveDetailDelegate> delegate;

-(void)loadWebPage;
-(void)loadWebActions;
-(void)loadCancel;

-(void)execAction;
-(void)execAction:(NSNumber *) theActionID;

-(id)initWithRecordID:(NSNumber *) theRecordID 
           screenName:(NSString *) theScreenName;

@end
