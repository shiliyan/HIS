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
        
        //加单元格标题栏背景
        titleBackground = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 25)]autorelease];
        titleBackground.backgroundColor = [UIColor colorWithRed:139.0/255 green:178.0/255 blue:38.0/255 alpha:1]; 
        titleBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview:titleBackground];
        
        // 加待办类型图片 
        typeImg = [[[UIImageView alloc]initWithFrame:CGRectMake(20, 1, 24, 24)]autorelease];
        typeImg.tag = TYPEIMG_IMAGEVIEW_TAG;
        typeImg.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:typeImg];
        
        // 加待办标题
        workflowTextView = [[[UILabel alloc]initWithFrame:CGRectMake(52, 2, 253, 21)]autorelease];
        workflowTextView.tag = WORKFLOW_TEXTVIEW_TAG;
        workflowTextView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;
        workflowTextView.adjustsFontSizeToFitWidth = YES;
        workflowTextView.backgroundColor  = [UIColor clearColor];
        [self.contentView addSubview:workflowTextView];
        
        // 加申请人
        applicantTextView = [[[UILabel alloc]initWithFrame:CGRectMake(20, 30, 80, 21)]autorelease];
        applicantTextView.tag = APPLICANT_TEXTVIEW_TAG;
        applicantTextView.autoresizingMask =UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;
        applicantTextView.adjustsFontSizeToFitWidth = YES;
        applicantTextView.backgroundColor  = [UIColor clearColor];
        [self.contentView addSubview:applicantTextView];
        
        // 加申请时间
        commitDateTextView = [[[UILabel alloc]initWithFrame:CGRectMake(20, 53, 100, 21)]autorelease];
        commitDateTextView.tag = COMMITDATE_TEXTVIEW_TAG;
        commitDateTextView.autoresizingMask =UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;
        commitDateTextView.adjustsFontSizeToFitWidth = true;
        commitDateTextView.backgroundColor  = [UIColor clearColor];
        [self.contentView addSubview:commitDateTextView];
        
        // 加审批动作名
        currentStatusTextView = [[[UILabel alloc]initWithFrame:CGRectMake(140, 30, 165, 21)]autorelease];
        currentStatusTextView.tag = CURRENTSTATUS_TEXTVIEW_TAG;
        currentStatusTextView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth;
        currentStatusTextView.textAlignment = UITextAlignmentRight;
        currentStatusTextView.adjustsFontSizeToFitWidth = YES;
        currentStatusTextView.backgroundColor  = [UIColor clearColor];
        [self.contentView addSubview:currentStatusTextView];
        
        //截止时间
        deadLineTextView = [[[UILabel alloc]initWithFrame:CGRectMake(205, 53, 100, 21)]autorelease];
        deadLineTextView.tag = DEADLINE_TEXTVIEW_TAG;
        deadLineTextView.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth;
        deadLineTextView.adjustsFontSizeToFitWidth = YES;
        deadLineTextView.textAlignment = UITextAlignmentRight;
        deadLineTextView.textColor = [UIColor redColor];
        deadLineTextView.backgroundColor  = [UIColor clearColor];
        [self.contentView addSubview:deadLineTextView];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    if(selected){
        titleBackground.backgroundColor = [UIColor clearColor]; 
    }else{
        titleBackground.backgroundColor = [UIColor grayColor]; 
    }
    
        
    // Configure the view for the selected state
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
