//
//  HDRoleSelectViewController.m
//  hrms
//
//  Created by Rocky Lee on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDRoleSelectViewController.h"
#import "HDRoleSelectDataSource.h"

@implementation HDRoleSelectViewController

-(id)initWithTitleName:(NSString *) title
{
    if (self = [self init]) 
    {
        self.tableViewStyle = UITableViewStyleGrouped;
        self.title =title;
    }
    return self;
}

-(void)createModel
{
    self.dataSource = [[[HDRoleSelectDataSource alloc]init] autorelease];
}

- (void)modelDidFinishLoad:(id<TTModel>)model
{
    HDRoleSelectModel * roleModel = (HDRoleSelectModel *)model;
    if (roleModel.isSelectedRole) {
        [[self parentViewController] dismissModalViewControllerAnimated:YES];
        return;
    }
    [super modelDidFinishLoad:model];
}

- (void)model:(id<TTModel>)model didFailLoadWithError:(NSError*)error
{
    TTAlertNoTitle([[error userInfo] valueForKeyPath:@"error"]);
}

@end
