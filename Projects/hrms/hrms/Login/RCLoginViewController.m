//
//  RCLoginViewController.m
//  HRMS
//
//  Created by Rocky Lee on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RCLoginViewController.h"
#import "LoginModel.h"
#import "UIViewController+HttpRequestHelper.h"


@implementation RCLoginViewController

static  NSString* kLoginURLPath  = @"http://localhost:8080/hrms/login.svc";

@synthesize username;
@synthesize password;

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
    TT_RELEASE_SAFELY(username);
    TT_RELEASE_SAFELY(password);
    //    TT_RELEASE_SAFELY(loginBtn);
    [super dealloc];
}

#pragma login functions
-(IBAction)loginBtnPressed:(id)sender{
    LoginModel * loginEntity = [[LoginModel alloc]init];
    loginEntity.username = [username text];
    loginEntity.password = [password text];
    
    [self formRequest:kLoginURLPath  
             withData:[loginEntity toDataSet] 
      successSelector:@selector(loginSecretFetchComplete:)  
       failedSelector:nil 
        errorSelector:nil
    noNetworkSelector:nil];
    [loginEntity release];
    /*
     *TODO:正式使用时开启回调部分跳转，这里忽略了服务端登陆请求
     */
    
    [[self parentViewController] dismissModalViewControllerAnimated:YES];
    
}

- (void)loginSecretFetchComplete:(id)dataSet
{
    //    NSLog(@"%@",[[dataSet objectAtIndex:0]valueForKey:@"user_name"]);
    [username resignFirstResponder];
    [password resignFirstResponder];
    
    [[self parentViewController] dismissModalViewControllerAnimated:YES];
//    [[TTNavigator navigator] openURLAction:[[[TTURLAction actionWithURLPath:@"tt://role_select"]
//                                             applyAnimated: YES]applyTransition:UIViewAnimationTransitionFlipFromRight]];
}

#pragma animations for keyborad

-(void)keyboardWillAppear:(BOOL)animated withBounds:(CGRect)bounds
{
    //    NSLog(@"%f,%f",bounds.size.width,bounds.size.height);
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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    [self.navigationController.navigationBar setHidden:NO];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    [self.username release];
    [self.password release];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
