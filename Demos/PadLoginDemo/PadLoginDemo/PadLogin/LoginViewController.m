//
//  LoginViewController.m
//  LoginDemo
//
//  Created by Stone Lee on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "RoleSelectViewController.h"
#import "UIViewController+HttpRequestHelper.h"

#define COOKBOOK_PURPLE_COLOR	[UIColor colorWithRed:0.0f green:0.2845f blue:0.55556f alpha:1.0f]

@interface LoginViewController()
- (void)loginSecretFetchComplete:(NSArray *)dataSet;
- (void)getRoleSecretFetchComplete:(NSArray *)dataSet;
@end

@implementation LoginViewController

#pragma customer functions
-(IBAction)loginBtnPressed:(id)sender
{
    //request with url
    NSDictionary * loginDic = [NSDictionary dictionaryWithObjectsAndKeys:[usernameTf text],@"user_name",[passwordTf text],@"user_password",@"简体中文",@"langugae",@"ZHS",@"user_language",@"N",@"is_ipad", nil];
    
    [self formRequest:@"http://localhost:8080/hrms/login.svc"
             withData:loginDic 
      successSelector:@selector(loginSecretFetchComplete:) 
       failedSelector:nil 
        errorSelector:nil];
}

//http://localhost:8080/hrms/login.svc
//http://localhost:8080/hrms/autocrud/sys.sys_user_role_groups/query

- (void)loginSecretFetchComplete:(NSMutableArray *) dataSet
{
    // Do any additional setup after loading the view from its nib.
    [self formRequest: @"http://localhost:8080/hrms/autocrud/sys.sys_user_role_groups/query"
             withData:nil 
      successSelector:@selector(getRoleSecretFetchComplete:)  
       failedSelector:nil 
        errorSelector:nil];
    
}

- (void)getRoleSecretFetchComplete:(NSMutableArray *)dataSet
{
    //    NSLog(@"catch");
    //    NSLog([theRequest responseString]);
    RoleSelectViewController * roleSelectViewCtrl = [[RoleSelectViewController alloc]initWithNibName:@"RoleSelectViewController" bundle:nil];
    roleSelectViewCtrl.roleMenu = dataSet;
    //animation
    [UIView beginAnimations:@"animation" context:nil];    
	[UIView setAnimationDuration:0.6f];
    [self.view addSubview:roleSelectViewCtrl.view];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
	[UIView commitAnimations];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization        
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{    
    [super viewDidUnload];    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
