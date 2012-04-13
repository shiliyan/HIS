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
#import "ApproveDatabaseHelper.h"

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

@property (nonatomic,retain) ApproveDatabaseHelper * dbHelper;

-(void)loadWebPage;
-(void)loadWebActions;
-(void)loadCancel;

-(void)execAction;
//-(void)execAction:(NSNumber *) theActionID;

-(id)initWithRecordID:(NSNumber *) theRecordID 
           screenName:(NSString *) theScreenName;

@end
