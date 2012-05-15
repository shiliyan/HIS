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
#import "ApproveDatabaseHelper.h"
#import "ASINetworkQueue.h"
#import "ApproveTableAdapter.h"
#import "HDURLCenter.h"
#import "HDHTTPRequestCenter.h"
#import "PullToRefreshViewController.h"

static NSString *ACTION_TYPE_ADOPT = @"Y";
static NSString *ACTION_TYPE_REFUSE = @"N";
static const NSString *DETAIL_REQUEST_KEY = @"detial_ready_post";



@interface ApproveListController :PullToRefreshViewController <UITableViewDelegate,ApproveOpinionViewDelegate,UISearchBarDelegate>{
    ApproveTableAdapter *_tableAdapter;
    
    HDFormDataRequest *_formRequest;
    ASINetworkQueue *_networkQueue;

    
    UIToolbar *_checkToolBar;
    
    UIBarButtonItem *_adoptButton;
    UIBarButtonItem *_refuseButton;
    UIView *_searchCoverView;
    
    ApproveDatabaseHelper *_dbHelper;
    
    ApproveListDetailController *_detailController;
    ApproveOpinionView *_opinionView;
    
    NSMutableArray *_animationCells;
    
    NSTimer *_timer;
    BOOL _inSearchStatus;
}

@property (retain, nonatomic) ApproveListDetailController *detailController;
@property (retain, nonatomic) HDFormDataRequest *formRequest;
@property (retain, nonatomic) ASINetworkQueue *networkQueue;
@property (retain, nonatomic) ApproveTableAdapter *tableAdapter;
@property (readonly,nonatomic) NSMutableArray *animationCells;

@property (retain,nonatomic) IBOutlet UIToolbar *checkToolBar;

@property (retain,nonatomic) IBOutlet UIBarButtonItem *adoptButton;
@property (retain,nonatomic) IBOutlet UIBarButtonItem *refuseButton;
@property (retain,nonatomic) IBOutlet UIView *searchCoverView;

-(void)commitApproveToServer;

//审批动作
-(IBAction)doAction:(id)sender;

@end
