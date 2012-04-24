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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma login delegate
-(void)loginSuccess:(NSArray *) dataSet
{
    self.roleList = dataSet;
    _roleSelectView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 412) style:UITableViewStyleGrouped];
    [_roleSelectView setDelegate:self];
    [self.view addSubview:_roleSelectView];
}

#pragma 重载taleview代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%i",[_roleList count]);
    return [_roleList count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if (_roleList) {
        cell.textLabel.text = [[_roleList objectAtIndex:indexPath.row]valueForKey:@"role_description"];
        cell.detailTextLabel.text = [[_roleList objectAtIndex:indexPath.row]valueForKey:@"company_short_name"];
    }
    return cell;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loginModel = [[[LoginModel alloc]init] autorelease];
    
//    _username.text = @"311";
//    _password.text = @"handhand";
    [self.loginModel setDelegate:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
