//
//  ApproveOpinionView.h
//  Approve
//
//  Created by mas apple on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApproveOpinionViewDelegate.h"

static const int RESULT_OK = 1;
static const int RESULT_CANCEL = 2;

@interface ApproveOpinionView : UIViewController{
    UILabel *titleLabel;
    UITextView *opinionTextView;
    
    NSUInteger approveType;
    
    id<ApproveOpinionViewDelegate> controllerDelegate;
}
@property(nonatomic) NSUInteger approveType;

@property(retain,nonatomic) IBOutlet UILabel *titleLabel;
@property(retain,nonatomic) IBOutlet UITextView *opinionTextView;

-(IBAction)commitData:(id)sender;
-(IBAction)cancelCommit:(id)sender;

-(void)setControllerDelegate:(id)inDelegate;

@end

