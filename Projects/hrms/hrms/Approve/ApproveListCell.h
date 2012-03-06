//
//  ApproveListCell.h
//  Approve
//
//  Created by mas apple on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Approve.h"

@interface ApproveListCell : UITableViewCell{
    Approve *approveData;
}

@property(retain, nonatomic) Approve *approveData;

@property(retain, nonatomic) IBOutlet UILabel *workflowTextView;
@property(retain, nonatomic) IBOutlet UILabel *currentStatusTextView;
@property(retain, nonatomic) IBOutlet UILabel *applicantTextView;
@property(retain, nonatomic) IBOutlet UILabel *commitDateTextView;
@property(retain, nonatomic) IBOutlet UILabel *deadLineTextView;
@property(retain, nonatomic) IBOutlet UIImageView *typeImg;


-(void)setCellDisplay;

-(void)gestureSwapRight;
@end
