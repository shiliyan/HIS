//
//  ApproveListController.h
//  Approve
//
//  Created by mas apple on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApproveListDetailController.h"

@interface ApproveListController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *approveListArray;
    
    UITableView *dataTableView;
    
    ApproveListDetailController *detailController;
    
    UIToolbar *normalToolbar;
    UIToolbar *checkToolBar;
    UILabel *bottomStatusLabel;
    UIBarButtonItem *adoptButton;
    UIBarButtonItem *refuseButton;
    
    NSMutableArray *testArray;
}

@property (retain, nonatomic) ApproveListDetailController *detailController;

-(void)toggleTabelViewEdit;

-(void)refreshTable;

//通过申请
-(void)adoptApplication;

//拒绝申请
-(void)refuseApplication;

-(void)deleteTableViewRows:(NSArray *)indexPathsArray;
@end
