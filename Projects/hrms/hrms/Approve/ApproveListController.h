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

static const int ACTION_TYPE_ADOPT = 1;
static const int ACTION_TYPE_REFUSE = 2;

static const int SECTION_APRROVE_LIST = 0;
static const int SECTION_WAITING_LIST = 1;
static const int SECTION_PROBLEM_LIST = 2;


@interface ApproveListController : UIViewController<UITableViewDataSource,UITableViewDelegate,ApproveOpinionViewDelegate>{
    NSMutableArray *approveListArray;
    NSMutableArray *problemListArray;
    NSMutableArray *commitListArray;
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
@property (retain, nonatomic) NSMutableArray *approveListArray;
@property (retain, nonatomic) NSMutableArray *problemListArray;
@property (retain, nonatomic) NSMutableArray *commitListArray;

@property (retain,nonatomic) IBOutlet UITableView *dataTableView;
@property (retain,nonatomic) IBOutlet UIToolbar *normalToolbar;
@property (retain,nonatomic) IBOutlet UIToolbar *checkToolBar;
@property (retain,nonatomic) IBOutlet UILabel *bottomStatusLabel;
@property (retain,nonatomic) IBOutlet UIBarButtonItem *adoptButton;
@property (retain,nonatomic) IBOutlet UIBarButtonItem *refuseButton;



-(IBAction)commitApproveToServer:(id)sender;

//通过申请
-(IBAction)adoptApplication:(id)sender;

//拒绝申请
-(IBAction)refuseApplication:(id)sender;
@end
