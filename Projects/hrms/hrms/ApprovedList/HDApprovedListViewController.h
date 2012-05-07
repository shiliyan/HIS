//
//  HDApprovedListViewControllerViewController.h
//  hrms
//
//  Created by Rocky Lee on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "ApprovedListModel.h"

@interface HDApprovedListViewController : TTTableViewController
<ApprovedListDelegate>
{
    ApprovedListModel * _approvedList;
}

@end
