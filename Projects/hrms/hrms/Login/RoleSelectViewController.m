//
//  RoleSelectViewController.m
//  hrms
//
//  Created by Rocky Lee on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RoleSelectViewController.h"



@implementation RoleSelectViewController

static  NSString *  kRoleSelectURLPath = @"http://localhost:8080/hrms/autocrud/sys.sys_user_role_groups/query";

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization 
        [self setPage];
        [self formRequest:kRoleSelectURLPath 
                 withData:nil 
          successSelector:@selector(loadTableData:) 
           failedSelector:nil 
            errorSelector:nil
        noNetworkSelector:nil];
    }
    return self;
}

-(void)loadTableData:(id) dataSet
{
    
    self.dataSource = [TTSectionedDataSource dataSourceWithArrays:
                       [NSArray arrayWithObjects:
                        @"",
                        [TTTableTextItem itemWithText:@"juese1" URL:@"tt://approve"],
                        [TTTableTextItem itemWithText:@"es" URL:@"tt://approve"],
                        nil]];
    
    [self loadView];
}

-(void) setPage{
    self.title = @"角色选择";
    self.tableViewStyle = UITableViewStyleGrouped;
    //    UIImage* image = [UIImage imageNamed:@"preferences.png"];
    //    self.tabBarItem = [[[UITabBarItem alloc] initWithTitle:self.title image:image tag:0] autorelease];
    //    self..tabBarItem. =YES;
       self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
                        @"",
                          
                          [TTTableTextItem itemWithText:@"角色1" delegate:self selector:@selector(gotoMain:)],
                           [TTTableTextItem itemWithText:@"角色2" 
                                                     URL:@"tt://approve"],
                           nil];
}

-(void) gotoMain:(NSInteger)index
{
    NSLog(@"%@",@"hi");
}

@end
