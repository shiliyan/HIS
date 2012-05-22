//
//  MainController.m
//  hrms
//
//  Created by mas apple on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainTabController.h"

static NSString *kHD_ACCOUNT_SETTING_VC_PATH = @"HD_ACCOUNT_SETTING_VC_PATH";
@interface MainTabController ()

@end

@implementation MainTabController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTabURLs:[NSArray arrayWithObjects:@"tt://approve",@"tt://approvedList",[[HDGodXMLFactory shareBeanFactory]actionURLPathWithKey:kHD_ACCOUNT_SETTING_VC_PATH], nil]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//- (void)exitApplication {    
//    [UIView beginAnimations:@"exitApplication" context:nil];    
//    [UIView setAnimationDuration:0.5];    
//    [UIView setAnimationDelegate:self];    
//    
//    [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:self.view.window cache:NO];    
//    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];    
//    self.view.window.bounds = CGRectMake(0, 0, 0, 0);    
//    [UIView commitAnimations];    
//}  
//- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {    
//    if ([animationID compare:@"exitApplication"] == 0) {    
//        exit(0);    
//    }  
//} 
@end
