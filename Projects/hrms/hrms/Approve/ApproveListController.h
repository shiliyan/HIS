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

static const int ACTION_TYPE_ADOPT = 1;
static const int ACTION_TYPE_REFUSE = 2;

@interface ApproveListController : UIViewController<UITableViewDelegate,ApproveOpinionViewDelegate>{
    ApproveTableAdapter *tableAdapter;
    NSUInteger loadCount;
    NSMutableArray *selectedArray;
    
    HDFormDataRequest *formRequest;
    ASINetworkQueue *networkQueue;
    
    UITableView *dataTableView;
    UIToolbar *normalToolbar;
    UIToolbar *checkToolBar;
    UILabel *bottomStatusLabel;
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
@property (retain, nonatomic) NSMutableArray *selectedArray;
@property (retain,nonatomic) IBOutlet UITableView *dataTableView;
@property (retain,nonatomic) IBOutlet UIToolbar *normalToolbar;
@property (retain,nonatomic) IBOutlet UIToolbar *checkToolBar;
@property (retain,nonatomic) IBOutlet UILabel *bottomStatusLabel;
@property (retain,nonatomic) IBOutlet UIBarButtonItem *adoptButton;
@property (retain,nonatomic) IBOutlet UIBarButtonItem *refuseButton;

-(IBAction)commitApproveToServer:(id)sender;

//审批动作
-(IBAction)doAction:(id)sender;

@end
