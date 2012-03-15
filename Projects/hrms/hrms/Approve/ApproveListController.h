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

static const int ACTION_TYPE_ADOPT = 1;
static const int ACTION_TYPE_REFUSE = 2;

@interface ApproveListController : UIViewController<UITableViewDataSource,UITableViewDelegate,ApproveOpinionViewDelegate>{
    NSMutableArray *approveListArray;
    
    UITableView *dataTableView;
    
    ApproveListDetailController *detailController;
    
    UIToolbar *normalToolbar;
    UIToolbar *checkToolBar;
    UILabel *bottomStatusLabel;
    UIBarButtonItem *adoptButton;
    UIBarButtonItem *refuseButton;
    
    ApproveOpinionView *opinionView;
}

@property (retain, nonatomic) ApproveListDetailController *detailController;

//
-(void)toggleTabelViewEdit:(id)sender;

-(void)refreshTable;

//通过申请
-(void)adoptApplication;

//拒绝申请
-(void)refuseApplication;

-(void)deleteTableViewRows:(NSArray *)indexPathsArray;

-(void)showOpinionView:(int)approveType;
@end
