//
//  DetailViewController.h
//  LoginDemo
//
//  Created by Stone Lee on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>
{
    UIWebView * webView;
    NSURL * url;
}

-(void)dismissMasterPopover;
-(void)refreshWebView;

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (retain,nonatomic) IBOutlet UIWebView * webView;
@property (retain,nonatomic) NSURL *url;

@end
