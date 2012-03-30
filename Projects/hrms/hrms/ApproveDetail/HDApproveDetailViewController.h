//
//  ApproveDetailViewController.h
//  hrms
//
//  Created by Rocky Lee on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Approve.h"
#import "ApproveOpinionViewDelegate.h"
#import "ApproveDatabaseHelper.h"

static const NSInteger BACK_VIEW =32;
static const NSInteger ACTIVE_LABEL =64;

@interface HDApproveDetailViewController : UIViewController
< ApproveOpinionViewDelegate >
{
    IBOutlet UIWebView * webView;
    IBOutlet UIToolbar * toolbar;
    
    Approve * approveDetailRecord;
    NSMutableDictionary * submitAction;
    
    ASIWebPageRequest * webPageRequest;
    HDFormDataRequest * toolBarDataRequest;
    HDFormDataRequest * actionRequest;
    
    ApproveDatabaseHelper *dbHelper;
}

@property (retain,nonatomic) Approve * approveDetailRecord;
@property (retain,nonatomic) NSMutableDictionary * submitAction;

@property (retain,nonatomic) ASIWebPageRequest * webPageRequest;
@property (retain,nonatomic) HDFormDataRequest * toolBarDataRequest;
@property (retain,nonatomic) HDFormDataRequest * actionRequest;

-(id)initWithName:(NSString*) name query:(NSDictionary *) record;

@end
