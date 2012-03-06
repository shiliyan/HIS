//
//  ApproveListCell.m
//  Approve
//
//  Created by mas apple on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ApproveListCell.h"

@implementation ApproveListCell

@synthesize approveData;

@synthesize workflowTextView;
@synthesize currentStatusTextView;
@synthesize applicantTextView;
@synthesize commitDateTextView;
@synthesize deadLineTextView;
@synthesize typeImg;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    
//    UISwipeGestureRecognizer *swapRight = [[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(gestureSwapRight)]autorelease];
//    swapRight.direction = UISwipeGestureRecognizerDirectionRight;
//    
//    [self addGestureRecognizer:swapRight];
    
    return self;
}

-(void)gestureSwapRight{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}


-(void)setCellDisplay{
    self.workflowTextView.text = self.approveData.workflowName;
    self.currentStatusTextView.text = self.approveData.currentStatus;
    self.applicantTextView.text = self.approveData.applicant;
    self.commitDateTextView.text = self.approveData.commitDate;
    self.deadLineTextView.text = self.approveData.deadLine;
    
    if([self.approveData.type isEqualToString:TODO_TYPE_HURRY]){
        self.typeImg.image = [UIImage imageNamed:@"hurry_todo.png"];
    }else if([self.approveData.type isEqualToString:TODO_TYPE_NORMAL]){
        self.typeImg.image = [UIImage imageNamed:@"normal_todo.png"];
    }

}

-(void)dealloc{
    [super dealloc];
    workflowTextView = nil;
    currentStatusTextView = nil;
    applicantTextView = nil;
    commitDateTextView = nil;
    deadLineTextView = nil;
    typeImg = nil;
    approveData =nil;
}


@end
