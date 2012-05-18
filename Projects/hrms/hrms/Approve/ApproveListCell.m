//
//  ApproveListCell2.m
//  Approve
//
//  Created by mas apple on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ApproveListCell.h"

@implementation ApproveListCell
@synthesize cellData = _cellData;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.autoresizesSubviews = YES;
        self.contentView.clipsToBounds = YES;
        
        // 加待办标题
        workflowNameLabel = [[[UILabel alloc]initWithFrame:CGRectMake(20, kCellContentFirstOriginY, 240, 20)]autorelease];
        workflowNameLabel.tag = TAG_WORKFLOW_LABEL;
        workflowNameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
        workflowNameLabel.adjustsFontSizeToFitWidth = NO;
        workflowNameLabel.backgroundColor  = [UIColor clearColor];
        
        [workflowNameLabel setFont:CELL_FONT(CELL_TITLE_FONTSIZE)];
        [self.contentView addSubview:workflowNameLabel];
        
        // 加申请时间
        commitDateTextView = [[[UILabel alloc]initWithFrame:CGRectMake(240, kCellContentFirstOriginY, 85, 20)]autorelease];
        commitDateTextView.tag = TAG_COMMITDATE_LABEL;
        commitDateTextView.autoresizingMask =UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin;
        commitDateTextView.adjustsFontSizeToFitWidth = NO;
        commitDateTextView.backgroundColor  = [UIColor clearColor];
        [commitDateTextView setFont:[UIFont fontWithName:@"Helvetica" size:12]];
//        [commitDateTextView setTextColor:RGBCOLOR(102, 102, 102)];
        [commitDateTextView setTextColor:[UIColor blueColor]];

        [self.contentView addSubview:commitDateTextView];
        
        alertBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"r.png"]];
        
        alertBackgroundView.opaque = false;
        alertBackgroundView.origin = CGPointMake(20, kCellContentFirstOriginY);
//        alertBackgroundView.frame = CGRectMake(20, kCellContentFirstOriginY, alertBackgroundView.image.size.width, alertBackgroundView.image.size.height);
//        alertBackgroundView.layer.shadowOffset = CGSizeMake(0.2, 0.2);
//        alertBackgroundView.layer.shadowColor = [[UIColor blackColor]CGColor];
//        alertBackgroundView.layer.shadowOpacity = 0.5;
        [self.contentView addSubview:alertBackgroundView];
        
        alertMessageLabel = [[UILabel alloc]initWithFrame:CGRectMake(alertBackgroundView.origin.x+6, alertBackgroundView.origin.y+3, 170, 15)];
        alertMessageLabel.backgroundColor = [UIColor clearColor];
        [alertMessageLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
        alertMessageLabel.textColor = [UIColor whiteColor];
        alertMessageLabel.adjustsFontSizeToFitWidth = NO;
        [alertBackgroundView addSubview:alertMessageLabel];
        
        
        // 加审批动作名
        currentStatusTextView = [[[UILabel alloc]initWithFrame:CGRectMake(20, kCellContentSecondOriginY, 300, 21)]autorelease];
        currentStatusTextView.tag = TAG_CURRENTSTATUS_LABEL;
        currentStatusTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        currentStatusTextView.textAlignment = UITextAlignmentLeft;
        currentStatusTextView.adjustsFontSizeToFitWidth = NO;
        currentStatusTextView.backgroundColor  = [UIColor clearColor];
        [currentStatusTextView setFont:[UIFont fontWithName:@"Helvetica" size:13]];
        [self.contentView addSubview:currentStatusTextView];
        
        //截止时间
        deadLineTextView = [[[UILabel alloc]initWithFrame:CGRectMake(20, kCellContentThirdOriginY, 295, 32)]autorelease];
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
        
        // 加待办类型图片 
//        typeImg = [[[UIImageView alloc]initWithFrame:CGRectMake(1, 29, 16, 16)]autorelease];
//        typeImg.tag = TAG_TYPEIMGVIEW;
//        typeImg.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
//        typeImg.contentMode = UIViewContentModeScaleAspectFit;
//        [self.contentView addSubview:typeImg];
        
        //提交中的遮罩
        coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, 320, 84)];
        coverView.backgroundColor = RGBACOLOR(237, 237, 237, 0.8);
        coverView.hidden = YES;
        [self.contentView addSubview:coverView];
        
        //提交中的进度指示
        indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.center = coverView.center;
        [coverView addSubview:indicatorView];
        
    }
    return self;
}

-(void)setCellData:(Approve *)approveEntity{
    [_cellData release];
    _cellData = [approveEntity retain];
    self.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    //设置共同的要显示数据
    workflowNameLabel.text = [NSString stringWithFormat:@"%@：%@",_cellData.orderType,_cellData.employeeName];
    
    if (_cellData.creationDate.length >= 10) {
        commitDateTextView.text = [_cellData.creationDate substringToIndex:10];
    }else {
        commitDateTextView.text = _cellData.creationDate;
    }
    
    deadLineTextView.text = _cellData.instanceDesc;
    currentStatusTextView.text = [NSString stringWithFormat:@"当前节点：%@",_cellData.nodeName];
    
    //根据数据内容，设置不同的属性
    if (_cellData.isLate.intValue == 0) {
        workflowNameLabel.textColor = [UIColor blackColor];
    }else {
        workflowNameLabel.textColor = [UIColor redColor];
    }
    
    
    if (([_cellData.localStatus isEqualToString:@"ERROR"]) || ([_cellData.localStatus isEqualToString:@"DIFFERENT"])) {
        coverView.hidden = YES;
        [indicatorView stopAnimating];
        indicatorView.hidden = YES;
        alertBackgroundView.hidden = NO;
        alertMessageLabel.text = _cellData.serverMessage;
        
        //计算信息栏占的高度
        float alertViewHeight = alertBackgroundView.frame.size.height;
        
        //移动工作流标题
        workflowNameLabel.origin = CGPointMake(workflowNameLabel.origin.x, kCellContentFirstOriginY+alertViewHeight);
        //移动提交时间
        commitDateTextView.origin = CGPointMake(commitDateTextView.origin.x, kCellContentFirstOriginY+alertViewHeight);
        //移动副标题
        currentStatusTextView.origin = CGPointMake(currentStatusTextView.origin.x, kCellContentSecondOriginY+alertViewHeight);
        //移动描述信息
        deadLineTextView.origin = CGPointMake(deadLineTextView.origin.x, kCellContentThirdOriginY + alertViewHeight);
        
        if ([_cellData.localStatus isEqualToString:@"DIFFERENT"]){
            alertBackgroundView.image = [UIImage imageNamed:@"g.png"];
            
        }else if([_cellData.localStatus isEqualToString:@"ERROR"]){
             alertBackgroundView.image = [UIImage imageNamed:@"r.png"];
           
        }else if ([_cellData.localStatus isEqualToString:@"WAITING"]){
            alertMessageLabel.text = @"等待提交中";
        }
    }
    
     else{
        alertBackgroundView.hidden = YES;
         
         //移动工作流标题
         workflowNameLabel.origin = CGPointMake(workflowNameLabel.origin.x, kCellContentFirstOriginY);
         //移动提交时间
         commitDateTextView.origin = CGPointMake(commitDateTextView.origin.x, kCellContentFirstOriginY);
         //移动副标题
         currentStatusTextView.origin = CGPointMake(currentStatusTextView.origin.x, kCellContentSecondOriginY);
         //移动描述信息
         deadLineTextView.origin = CGPointMake(deadLineTextView.origin.x, kCellContentThirdOriginY);
         
         if ([_cellData.localStatus isEqualToString:@"WAITING"]) {
             coverView.hidden = NO;
             indicatorView.hidden = NO;
             [indicatorView startAnimating];
         }else {
             coverView.hidden = YES;
             indicatorView.hidden = YES;
             [indicatorView stopAnimating];
         }
        
    }
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    alertMessageLabel.backgroundColor = [UIColor clearColor];
}

-(void)dealloc{
    [_cellData release];
    [workflowNameLabel release];
    [currentStatusTextView release];
    [commitDateTextView release];
    [deadLineTextView release];
    [typeImg release];
    [super dealloc];
}
@end
