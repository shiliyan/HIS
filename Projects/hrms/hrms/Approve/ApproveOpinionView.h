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
    
    UIButton *okButton;
    UIButton *cancelButton;
    
    id<ApproveOpinionViewDelegate> controllerDelegate;
}


-(void)toggleOutKeybord:(id)sender;

-(void)commitData;
-(void)cancelCommit;

-(void)setControllerDelegate:(id)inDelegate;

@end

