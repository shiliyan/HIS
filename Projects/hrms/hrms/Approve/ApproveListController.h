//
//  ApproveListController.h
//  Approve
//
//  Created by mas apple on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApproveListDetailController.h"
#import "ApproveOpinionView.h"
#import "ApproveOpinionViewDelegate.h"
#import "ApproveDatabaseHelper.h"
#import "ASINetworkQueue.h"
#import "ApproveTableAdapter.h"
#import "HDURLCenter.h"
#import "HDHTTPRequestCenter.h"
#import "PullToRefreshViewController.h"

static NSString *ACTION_TYPE_ADOPT = @"Y";
static NSString *ACTION_TYPE_REFUSE = @"N";
static const NSString *DETAIL_REQUEST_KEY = @"detial_ready_post";



@interface ApproveListController :PullToRefreshViewController <UITableViewDelegate,ApproveOpinionViewDelegate>{
    ApproveTableAdapter *tableAdapter;
    
    HDFormDataRequest *formRequest;
    ASINetworkQueue *networkQueue;

    
    UIToolbar *checkToolBar;
    
    UIBarButtonItem *adoptButton;
    UIBarButtonItem *refuseButton;
    
    ApproveDatabaseHelper *dbHelper;
    
    ApproveListDetailController *detailController;
    ApproveOpinionView *opinionView;
}

@property (retain, nonatomic) ApproveListDetailController *detailController;
@property (retain, nonatomic) HDFormDataRequest *formRequest;
@property (retain, nonatomic) ASINetworkQueue *networkQueue;
@property (retain, nonatomic) ApproveTableAdapter *tableAdapter;

@property (retain,nonatomic) IBOutlet UIToolbar *checkToolBar;

@property (retain,nonatomic) IBOutlet UIBarButtonItem *adoptButton;
@property (retain,nonatomic) IBOutlet UIBarButtonItem *refuseButton;

-(IBAction)commitApproveToServer:(id)sender;

//审批动作
-(IBAction)doAction:(id)sender;

@end
