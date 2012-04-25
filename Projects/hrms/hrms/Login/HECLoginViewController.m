//
//  HECLoginViewController.m
//  hrms
//
//  Created by Rocky Lee on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HECLoginViewController.h"

@interface HECLoginViewController ()

@end

@implementation HECLoginViewController

@synthesize roleSelectView = _roleSelectView;
@synthesize roleSelectModule = _roleSelectModule;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"RCLoginViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma 重载父类的登陆成功方法,添加角色选择页面
-(void)loginSuccess:(NSArray *) dataSet
{
    //加载角色选择tableView 并刷新数据
    self.roleSelectModule = [[HDRoleSelectModule alloc]initWithDataSet:dataSet];
    
    [_roleSelectModule setDelegate:self];
    _roleSelectView = [[TTTableView alloc]initWithFrame:CGRectMake(0, 0, 320, 460) style:UITableViewStyleGrouped];
    [_roleSelectView setDelegate:self];
    [_roleSelectView setDataSource:self];
    
    //动画
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    [UIView setAnimationDuration:1];
    [self.view addSubview:_roleSelectView];
    [UIView commitAnimations];
    
    [_roleSelectView reloadData];
}

#pragma 重载taleview代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_roleSelectModule roleCount];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;   
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    id roleInfo = [_roleSelectModule roleAtIndex:indexPath.row];
    if (roleInfo) {
        cell.textLabel.text = [roleInfo valueForKey:@"role_description"];
        cell.detailTextLabel.text = [roleInfo valueForKey:@"company_description"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_roleSelectModule selectRoleAtIndex:indexPath.row];
}

#pragma -mark 实现角色选择代理方法
-(void)roleSelectSuccess:(NSArray *)dataSet
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)roleSelectFailed:(NSString *)errorMessage
{
    [self loginFailed:errorMessage];
    [_roleSelectView  deselectRowAtIndexPath: _roleSelectView.indexPathForSelectedRow animated:YES];
}

- (void)viewDidUnload
{
    TT_RELEASE_SAFELY(_roleSelectModule);
    TT_RELEASE_SAFELY(_roleSelectView);
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
