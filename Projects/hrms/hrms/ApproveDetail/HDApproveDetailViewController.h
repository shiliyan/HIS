//
//  ApproveDetailViewController.h
//  hrms
//
//  Created by Rocky Lee on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "HDApproveDetailModel.h"
#import "ApproveOpinionView.h"
#import "HDApproveModule.h"

static const NSInteger BACK_VIEW =32;
static const NSInteger ACTIVE_LABEL =64;

static const NSInteger HD_APPROVE_NORMAL = 3;
static const NSInteger HD_APPROVE_ERROR = 6;
static const NSInteger HD_APPROVE_EXCEPTION = 9;

static const NSString * HD_APPROVE_DATA  = @"data";

@interface HDApproveDetailViewController : UIViewController
< ApproveOpinionViewDelegate ,HDApproveDetailDelegate>

@property (nonatomic,retain) IBOutlet UIWebView * webPage;
@property (nonatomic,retain) IBOutlet UIToolbar * toolbar;

//@property (nonatomic,retain) HDApproveDetailModel * detailModel;
@property (nonatomic,retain) HDApproveModule * detailModule;

@property (nonatomic,assign) NSInteger loadType;

-(id)initWithName:(NSString *) name 
            query:(NSDictionary *) query;

@end
