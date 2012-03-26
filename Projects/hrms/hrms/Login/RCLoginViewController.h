//
//  RCLoginViewController.h
//  HRMS
//
//  Created by Rocky Lee on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


@interface RCLoginViewController : TTBaseViewController <TTURLRequestDelegate>{
    HDFormDataRequest * formDataRequest;
}

@property (nonatomic,retain) HDFormDataRequest * formDataRequest;
@property (nonatomic,retain) IBOutlet UITextField * username;
@property (nonatomic,retain) IBOutlet UITextField * password;
//@property (nonatomic,retain) IBOutlet UIButton * loginBtn;

-(IBAction)loginBtnPressed:(id)sender;

@end
