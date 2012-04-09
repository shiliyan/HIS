//
//  RCLoginViewController.h
//  HRMS
//
//  Created by Rocky Lee on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginModel.h"

@interface RCLoginViewController : TTBaseViewController <HDLoginDelegate>
{
}

@property (nonatomic,retain) LoginModel * loginModel;
@property (nonatomic,retain) IBOutlet UITextField * username;
@property (nonatomic,retain) IBOutlet UITextField * password;


-(IBAction)loginBtnPressed:(id)sender;

@end
