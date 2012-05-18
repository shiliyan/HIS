//
//  RCLoginViewController.m
//  HRMS
//
//  Created by Rocky Lee on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDLoginViewController.h"

static NSString * kRoleSelectPathName = @"HD_ROLE_SELECT_VC_PATH";

@implementation HDLoginViewController

@synthesize username = _username;
@synthesize password = _password;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setAutoresizesForKeyboard:YES];
    }
    return self;
}

-(void)createModel
{
    //这里通过url创建
    _model = [[HDLoginModel alloc]init];
    _loginModel = (HDLoginModel *)_model;
    [[_loginModel delegates] addObject:self];
    _username.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    _password.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
}

#pragma login functions
-(IBAction)loginBtnPressed:(id)sender{
    [_username resignFirstResponder];
    [_password resignFirstResponder];
    [_loginModel setUsername:_username.text];
    [_loginModel setPassword:_password.text];
    [_loginModel load:TTURLRequestCachePolicyNetwork more:NO];
}

//模型delegate方法
- (void)modelDidFinishLoad:(id<TTModel>)model
{
    NSString * roleSelectPath =  [[HDGodXMLFactory shareBeanFactory] actionURLPathWithKey:kRoleSelectPathName];
    if (!roleSelectPath) {
        [[self parentViewController] dismissModalViewControllerAnimated:YES];
    }else {
        [[HDNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:roleSelectPath]applyAnimated:YES]];
    }
}

- (void)model:(id<TTModel>)model didFailLoadWithError:(NSError*)error
{
    TTAlertNoTitle([[error userInfo] valueForKeyPath:@"errorMessage"]);
    TTDPRINT(@"%@",[[error userInfo] valueForKeyPath:@"error"]);
}

#pragma animations for keyborad
-(void)keyboardWillAppear:(BOOL)animated withBounds:(CGRect)bounds
{
    [UIView beginAnimations:@"keyboardAnimation" context:NULL];
    for (UIView * subView in [self.view subviews]) {
        CGAffineTransform moveTransform = CGAffineTransformMakeTranslation(0, -120);
        [subView.layer setAffineTransform:moveTransform];
    }
    [UIView commitAnimations];
}

-(void)keyboardWillDisappear:(BOOL)animated withBounds:(CGRect)bounds
{
    [UIView beginAnimations:@"keyboardAnimation" context:NULL];
    for (UIView * subView in [self.view subviews]) {
        CGAffineTransform moveTransform = CGAffineTransformMakeTranslation(0, 0);
        [subView.layer setAffineTransform:moveTransform];
    }
    [UIView commitAnimations];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
    [super viewWillDisappear:animated];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
