//
//  HDApprovedListViewControllerViewController.m
//  hrms
//
//  Created by Rocky Lee on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDApprovedListViewController.h"
#import "HDApprovedListDataSource.h"
#import "HDApprovedListSearchDataSource.h"

@interface HDApprovedListViewController ()

@end

@implementation HDApprovedListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"审批完成";
        self.variableHeightRows = YES;
        self.tabBarItem.image = [UIImage imageNamed:@"mailopened.png"];
    }
    return self;
}

-(void)createModel
{
    self.dataSource = [[[HDApprovedListDataSource alloc]init] autorelease];
}

//-(void)loadView
//{
//    [super loadView];
//    TTTableViewController* searchController = [[[TTTableViewController alloc] init] autorelease];
//    searchController.dataSource = [[HDApprovedListSearchDataSource alloc] autorelease];
//    self.searchViewController = searchController;
//    self.tableView.tableHeaderView = _searchController.searchBar;
//}

@end
