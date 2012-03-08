//
//  LoginViewController.h
//  LoginDemo
//
//  Created by Stone Lee on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
{
    IBOutlet UITextField* usernameTf;
    IBOutlet UITextField * passwordTf;
    IBOutlet UIButton * loginBtn;
}

-(IBAction)loginBtnPressed:(id)sennder;

@end
