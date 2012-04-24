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
@synthesize roleList = _roleList;
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
    self.roleList = dataSet;  
    //加载角色选择tableView 并刷新数据
    _roleSelectView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, 320, 412) style:UITableViewStyleGrouped];
    [_roleSelectView setDelegate:self];
    [_roleSelectView setDataSource:self];
    [self.view addSubview:_roleSelectView];
    [_roleSelectView reloadData];
}

#pragma 重载taleview代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_roleList count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if (_roleList) {
        cell.textLabel.text = [[_roleList objectAtIndex:indexPath.row]valueForKey:@"role_code"];
        cell.detailTextLabel.text = [[_roleList objectAtIndex:indexPath.row]valueForKey:@"role_code"];
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //调用角色选择
    self.roleSelectModule = [[HDRoleSelectModule alloc]init];
    [_roleSelectModule setDelegate:self];
    [_roleSelectModule setRoleSelectFailedSelector:@selector(loginFailed:)];
    [_roleSelectModule selectRole:[_roleList objectAtIndex:indexPath.row]];
}

#pragma -mark 实现角色选择代理方法
-(void)roleSelectSuccess:(NSArray *)dataSet
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    TT_RELEASE_SAFELY(_roleSelectModule);
    TT_RELEASE_SAFELY(_roleList);
    TT_RELEASE_SAFELY(_roleSelectView);
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
