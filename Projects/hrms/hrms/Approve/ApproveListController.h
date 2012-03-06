//
//  ApproveListController.h
//  Approve
//
//  Created by mas apple on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApproveListDetailController.h"

@interface ApproveListController : UITableViewController{
    NSMutableArray *approveListArray;
    ApproveListDetailController *detailController;
}

@property (retain, nonatomic) NSMutableArray *approveListArray;
@property (retain, nonatomic) ApproveListDetailController *detailController;

@end
