//
//  RCLoginViewController.m
//  HRMS
//
//  Created by Rocky Lee on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RCLoginViewController.h"

@implementation RCLoginViewController

@synthesize username = _username;
@synthesize password = _password;
@synthesize loginModel = _loginModel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization 
        [self setAutoresizesForKeyboard:YES];
    }
    return self;
}

-(void)dealloc{
    TT_RELEASE_SAFELY(_username);
    TT_RELEASE_SAFELY(_password);
    TT_RELEASE_SAFELY(_loginModel);
    [super dealloc];
}

#pragma login functions
-(IBAction)loginBtnPressed:(id)sender{
    [_username resignFirstResponder];
    [_password resignFirstResponder];
    
    [self.loginModel setUsername:_username.text];
    [self.loginModel setPassword:_password.text];    
    
    [self.loginModel login];
}

#pragma login delegate
-(void)loginSuccess:(NSArray *) dataSet
{
    //TODO:未开启跳转
    [[self parentViewController] dismissModalViewControllerAnimated:YES];
}

-(void)loginFailed:(NSString *) errorMessage;
{
    NSLog(@"failed");
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"错误" message:errorMessage delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [alert show];
    [alert release];
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
    //    NSLog(@"%f,%f",bounds.size.width,bounds.size.height);
    [UIView beginAnimations:@"keyboardAnimation" context:NULL];
    for (UIView * subView in [self.view subviews]) {
        CGAffineTransform moveTransform = CGAffineTransformMakeTranslation(0, 0);
        [subView.layer setAffineTransform:moveTransform];
    }
    [UIView commitAnimations];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _loginModel = [[LoginModel alloc]init];

    _username.text = @"311";
    _password.text = @"handhand";
    [self.loginModel setDelegate:self];
}

- (void)viewDidUnload
{
//    TT_RELEASE_SAFELY(_username);
//    TT_RELEASE_SAFELY(_password);
//    TT_RELEASE_SAFELY(_loginModel);
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

@end
