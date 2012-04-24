//
//  RCLoginViewController.h
//  HRMS
//
//  Created by Rocky Lee on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDLoginModule.h"

@interface RCLoginViewController : TTBaseViewController <HDLoginDelegate>

@property (nonatomic,retain) HDLoginModule * loginModule;
@property (nonatomic,retain) IBOutlet UITextField * username;
@property (nonatomic,retain) IBOutlet UITextField * password;


-(IBAction)loginBtnPressed:(id)sender;

-(void)loginSuccess:(NSArray *) dataSet;

-(void)loginFailed:(NSString *) errorMessage;

@end
