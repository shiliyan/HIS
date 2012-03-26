//
//  ApproveDetailViewController.h
//  hrms
//
//  Created by Rocky Lee on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Approve.h"
#import "ASIWebPageRequest.h"
#import "ASIDownloadCache.h"

@interface HDApproveDetailViewController : UIViewController
{
    IBOutlet UIWebView * webView;
    IBOutlet UIToolbar * toolbar;
    
    Approve * approveDetailRecord;
    ASIWebPageRequest * webPageRequest;
    HDFormDataRequest *formDataRequest;
}

@property (retain,nonatomic) Approve * approveDetailRecord;
@property (retain,nonatomic) ASIWebPageRequest * webPageRequest;
@property (retain,nonatomic) HDFormDataRequest * formDataRequest;

-(id)initWithName:(NSString*) name query:(NSDictionary *) record;

@end
