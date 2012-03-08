//
//  MasterViewController.h
//  LoginDemo
//
//  Created by Stone Lee on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeModel.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController<UINavigationControllerDelegate>
{
    NSMutableArray * menu;
    NSDictionary * selectedNode;
    DetailViewController * detailViewController;
}

@property (retain,nonatomic) NSMutableArray * menu;
@property (retain,nonatomic) DetailViewController * detailViewController;

@end
