//
//  ApproveDetailViewController.h
//  hrms
//
//  Created by Rocky Lee on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDApproveDetailModel.h"
#import "ApproveOpinionView.h"

static const NSInteger BACK_VIEW =32;
static const NSInteger ACTIVE_LABEL =64;

static const NSInteger HD_LOAD_WITHOUT_ACTION = 3;
static const NSInteger HD_LOAD_WITH_ACTION = 6;

@interface HDApproveDetailViewController : UIViewController
< ApproveOpinionViewDelegate ,HDApproveDetailDelegate>

@property (nonatomic,retain) IBOutlet UIWebView * webPage;
@property (nonatomic,retain) IBOutlet UIToolbar * toolbar;

@property (nonatomic,retain) HDApproveDetailModel * approveModel;

@property (nonatomic,assign) NSInteger loadType;

-(id)initWithName:(NSString *) name 
         recordID:(NSInteger) theRecordID 
       screenName:(NSString *) theScreenName
         loadType:(NSInteger) type;

@end
