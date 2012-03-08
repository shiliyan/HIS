//
//  RoleSelectViewController.h
//  LoginDemo
//
//  Created by Stone Lee on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoleSelectViewController : UITableViewController

{
    //    IBOutlet UITableView * roleSelectView;
    NSMutableArray * roleMenu;
}

@property (strong, nonatomic) UISplitViewController *splitViewController;
//@property (nonatomic,retain) IBOutlet UITableView * roleSelectView;

@property (nonatomic,retain) NSMutableArray * roleMenu;

@end
