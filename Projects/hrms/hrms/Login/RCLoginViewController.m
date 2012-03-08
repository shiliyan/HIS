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

static  NSString* kLoginURLPath  = @"http://172.20.0.72:8080/hrmsdev_new/login.svc";

@synthesize username;
@synthesize password;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization 
        self.autoresizesForKeyboard=YES;
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
        errorSelector:nil];
    [loginEntity release];
}

- (void)loginSecretFetchComplete:(id)dataSet
{
//    NSLog(@"%@",[[dataSet objectAtIndex:0]valueForKey:@"user_name"]);
    [username resignFirstResponder];
    [password resignFirstResponder];
    
    [[TTNavigator navigator] openURLAction:[[[TTURLAction actionWithURLPath:@"tt://main"]
                                             applyAnimated: YES]applyTransition:UIViewAnimationTransitionFlipFromRight]];
}

#pragma animations for keyborad
-(void)keyboardWillAppear:(BOOL)animated withBounds:(CGRect)bounds{
    //    NSLog(@"%f,%f",bounds.size.width,bounds.size.height);
    [UIView beginAnimations:@"keyboardAnimation" context:NULL];
    for (UIView * subView in [self.view subviews]) {
        CGAffineTransform moveTransform = CGAffineTransformMakeTranslation(0, -100);
        [subView.layer setAffineTransform:moveTransform];
    }
    [UIView commitAnimations];
    
}

-(void)keyboardWillDisappear:(BOOL)animated withBounds:(CGRect)bounds{
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
    [self.navigationController.navigationBar setHidden:YES];
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
