//
//  HDApprovedListViewControllerViewController.m
//  hrms
//
//  Created by Rocky Lee on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDApprovedListViewController.h"
#import "HDApprovedListDataSource.h"

@interface HDApprovedListViewController ()

@end

@implementation HDApprovedListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(queryData)];
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

-(void)loadView
{
    [super loadView];
    TTTableViewController* searchController = [[[TTTableViewController alloc] init] autorelease];
    searchController.dataSource = [[HDApprovedListDataSource alloc] autorelease];
    self.searchViewController = searchController;
    self.tableView.tableHeaderView = _searchController.searchBar;
}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
////    [_approvedList loadApprovedList];
//}

//-(void)queryData
//{
//    TTAlert(@"弹出模态视图,输入查询条件查询");
//}

//-(void)loadSuccess:(NSArray *)dataSet
//{
//    TTListDataSource* dataSource = [[[TTListDataSource alloc] init] autorelease];
//    for (NSDictionary * record in dataSet) {
//        NSString * textContent = [NSString stringWithFormat:@"%@ - %@" ,[record valueForKey:@"status_name"],[record valueForKey:@"instance_desc"]];
//        NSString * screenUrl = [NSString stringWithFormat:@"%@?doc_page_url=%@&instance_id=%@",[HDURLCenter requestURLWithKey:@"APPROVE_DETIAL_WEB_PAGE_PATH"],[record valueForKey:@"doc_page_url"],[record valueForKey:@"instance_id"]];
//
//        [NSString stringWithFormat:@"%@?record_id=%@",[HDURLCenter requestURLWithKey:@"APPROVE_SCREEN_BASE_PATH"],[record valueForKey:@" service_name"]];
//        TTDPRINT(@"%@",screenUrl);
//        
//        [dataSource.items addObject:
//         [TTTableMessageItem itemWithTitle:[record valueForKey:@"order_type"] 
//                                   caption:[record valueForKey:@"workflow_name"]
//                                      text:textContent 
//                                 timestamp:nil
//                                  imageURL:nil 
//                                       URL:screenUrl]];
//    }
//    self.dataSource = dataSource;
//}

//-(void)loadFailed:(NSString *) errorMessage;
//{
//    TTAlertNoTitle(errorMessage);
//    self.dataSource = [TTListDataSource dataSourceWithObjects:nil];
//}

@end
