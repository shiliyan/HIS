//
//  ApproveListCell2.m
//  Approve
//
//  Created by mas apple on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ApproveListCell.h"

@implementation ApproveListCell

@synthesize approveData;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.autoresizesSubviews = YES;
        self.contentView.clipsToBounds = YES;
        
        // 加待办标题
        workflowTextView = [[[UILabel alloc]initWithFrame:CGRectMake(20, 5, 240, 20)]autorelease];
        workflowTextView.tag = WORKFLOW_TEXTVIEW_TAG;
        workflowTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
        workflowTextView.adjustsFontSizeToFitWidth = NO;
        workflowTextView.backgroundColor  = [UIColor clearColor];
        
        [workflowTextView setFont:CELL_FONT(CELL_TITLE_FONTSIZE)];
        [self.contentView addSubview:workflowTextView];
        
        // 加申请时间
        commitDateTextView = [[[UILabel alloc]initWithFrame:CGRectMake(220, 5, 100, 20)]autorelease];
        commitDateTextView.tag = COMMITDATE_TEXTVIEW_TAG;
        commitDateTextView.autoresizingMask =UIViewAutoresizingFlexibleWidth;
        commitDateTextView.adjustsFontSizeToFitWidth = NO;
        commitDateTextView.backgroundColor  = [UIColor clearColor];
        [commitDateTextView setFont:[UIFont fontWithName:@"Helvetica" size:11]];
        [commitDateTextView setTextColor:[UIColor blueColor]];
        [self.contentView addSubview:commitDateTextView];
        
        // 加审批动作名
        currentStatusTextView = [[[UILabel alloc]initWithFrame:CGRectMake(20, 25, 300, 21)]autorelease];
        currentStatusTextView.tag = CURRENTSTATUS_TEXTVIEW_TAG;
        currentStatusTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        currentStatusTextView.textAlignment = UITextAlignmentLeft;
        currentStatusTextView.adjustsFontSizeToFitWidth = NO;
        currentStatusTextView.backgroundColor  = [UIColor clearColor];
        [currentStatusTextView setFont:[UIFont fontWithName:@"Helvetica" size:13]];
        [self.contentView addSubview:currentStatusTextView];
        
        //截止时间
        deadLineTextView = [[[UILabel alloc]initWithFrame:CGRectMake(20, 45, 300, 32)]autorelease];
        deadLineTextView.tag = DEADLINE_TEXTVIEW_TAG;
        deadLineTextView.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        deadLineTextView.adjustsFontSizeToFitWidth = NO;
        deadLineTextView.textAlignment = UITextAlignmentLeft;
        deadLineTextView.textColor = [UIColor grayColor];
        deadLineTextView.backgroundColor  = [UIColor clearColor];
        [deadLineTextView setFont:[UIFont fontWithName:@"Helvetica" size:13]];
        [deadLineTextView setLineBreakMode:UILineBreakModeCharacterWrap];
        [deadLineTextView setNumberOfLines:2];
        [self.contentView addSubview:deadLineTextView];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];    
    // Configure the view for the selected state
}

-(void)setCellData:(Approve *)approveEntity{
    
    workflowTextView.text = [NSString stringWithFormat:@"%@：%@",approveEntity.workflowName,approveEntity.employeeName];
    currentStatusTextView.text = [NSString stringWithFormat:@"当前节点：%@",approveEntity.nodeName];
    commitDateTextView.text = approveEntity.creationDate;
    deadLineTextView.text = approveEntity.workflowDesc;
    
}


-(void)dealloc{
    [approveData release];
    [workflowTextView release];
    [currentStatusTextView release];
    [applicantTextView release];
    [commitDateTextView release];
    [deadLineTextView release];
    [typeImg release];
    [super dealloc];
}

@end
