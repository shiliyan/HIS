//
//  ApproveListCell2.m
//  Approve
//
//  Created by mas apple on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ApproveListCell.h"

@implementation ApproveListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.autoresizesSubviews = YES;
        self.contentView.clipsToBounds = YES;
        
        // 加待办标题
        workflowNameLabel = [[[UILabel alloc]initWithFrame:CGRectMake(20, 5, 240, 20)]autorelease];
        workflowNameLabel.tag = TAG_WORKFLOW_LABEL;
        workflowNameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
        workflowNameLabel.adjustsFontSizeToFitWidth = NO;
        workflowNameLabel.backgroundColor  = [UIColor clearColor];
        
        [workflowNameLabel setFont:CELL_FONT(CELL_TITLE_FONTSIZE)];
        [self.contentView addSubview:workflowNameLabel];
        
        // 加申请时间
        commitDateTextView = [[[UILabel alloc]initWithFrame:CGRectMake(245, 5, 75, 20)]autorelease];
        commitDateTextView.tag = TAG_COMMITDATE_LABEL;
        commitDateTextView.autoresizingMask =UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin;
        commitDateTextView.adjustsFontSizeToFitWidth = NO;
        commitDateTextView.backgroundColor  = [UIColor clearColor];
        [commitDateTextView setFont:[UIFont fontWithName:@"Helvetica" size:11]];
        [commitDateTextView setTextColor:[UIColor blueColor]];
        [self.contentView addSubview:commitDateTextView];
        
        alertBackgroundView = [[[UIView alloc]initWithFrame:CGRectMake(25, 28, 295, 18)]autorelease];
        
        alertBackgroundView.opaque = false;
        alertBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview:alertBackgroundView];
        
        // 加审批动作名
        currentStatusTextView = [[[UILabel alloc]initWithFrame:CGRectMake(20, 25, 300, 21)]autorelease];
        currentStatusTextView.tag = TAG_CURRENTSTATUS_LABEL;
        currentStatusTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        currentStatusTextView.textAlignment = UITextAlignmentLeft;
        currentStatusTextView.adjustsFontSizeToFitWidth = NO;
        currentStatusTextView.backgroundColor  = [UIColor clearColor];
        [currentStatusTextView setFont:[UIFont fontWithName:@"Helvetica" size:13]];
        [self.contentView addSubview:currentStatusTextView];
        
        //截止时间
        deadLineTextView = [[[UILabel alloc]initWithFrame:CGRectMake(20, 45, 295, 32)]autorelease];
        deadLineTextView.tag = TAG_DEADLINE_LABEL;
        deadLineTextView.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        deadLineTextView.adjustsFontSizeToFitWidth = NO;
        deadLineTextView.textAlignment = UITextAlignmentLeft;
        deadLineTextView.textColor = [UIColor grayColor];
        deadLineTextView.backgroundColor  = [UIColor clearColor];
        [deadLineTextView setFont:[UIFont fontWithName:@"Helvetica" size:13]];
        [deadLineTextView setLineBreakMode:UILineBreakModeCharacterWrap];
        [deadLineTextView setNumberOfLines:2];
        [self.contentView addSubview:deadLineTextView];
        
        typeImg = [[[UIImageView alloc]initWithFrame:CGRectMake(1, 29, 16, 16)]autorelease];
        // 加待办类型图片 

        typeImg.tag = TAG_TYPEIMGVIEW;
        typeImg.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
        typeImg.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:typeImg];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];    
    // Configure the view for the selected state
}

-(void)setCellData:(Approve *)approveEntity{
    
    workflowNameLabel.text = [NSString stringWithFormat:@"%@：%@",approveEntity.workflowName,approveEntity.employeeName];
    
    commitDateTextView.text = [approveEntity.creationDate substringToIndex:10];
    deadLineTextView.text = approveEntity.workflowDesc;
    
    if (approveEntity.isLate == 0) {
        workflowNameLabel.textColor = [UIColor blackColor];
    }else {
        workflowNameLabel.textColor = [UIColor redColor];
    }
    
    if ([approveEntity.localStatus isEqualToString:@"DIFFERENT"]){
        typeImg.image = [UIImage imageNamed:@"alert.png"];
        alertBackgroundView.backgroundColor = [UIColor colorWithRed:(255/255) green:(255/255) blue:(0/255) alpha:0.2f];
        typeImg.hidden = NO;
        alertBackgroundView.hidden = NO;
        currentStatusTextView.text = approveEntity.serverMessage;
    }else if([approveEntity.localStatus isEqualToString:@"ERROR"]){
        typeImg.image = [UIImage imageNamed:@"error.png"];
        alertBackgroundView.backgroundColor = [UIColor colorWithRed:(255/255) green:(0/255) blue:(0/255) alpha:0.2f];
        typeImg.hidden = NO;
        alertBackgroundView.hidden = NO;
        currentStatusTextView.text = approveEntity.serverMessage;
    }else{
        typeImg.hidden = YES;
        alertBackgroundView.hidden = YES;
        currentStatusTextView.text = [NSString stringWithFormat:@"当前节点：%@",approveEntity.nodeName];
    }
}

-(void)dealloc{
    [workflowNameLabel release];
    [currentStatusTextView release];
    [commitDateTextView release];
    [deadLineTextView release];
    [typeImg release];
    [super dealloc];
}
@end
