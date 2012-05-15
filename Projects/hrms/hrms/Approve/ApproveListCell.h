//
//  ApproveListCell2.h
//  Approve
//
//  Created by mas apple on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Approve.h"

#define CELL_TITLE_FONTSIZE     17

#define CELL_FONT(s)     [UIFont fontWithName:@"Helvetica-Bold" size:s]

#define CELL_BOLDFONT(s) [UIFont fontWithName:@"Helvetica-BoldOblique" size:s]

static const int const TAG_WORKFLOW_LABEL = 1;
static const int const TAG_CURRENTSTATUS_LABEL = 2;
static const int const TAG_TYPEIMGVIEW = 3;
static const int const TAG_COMMITDATE_LABEL = 4;
static const int const TAG_DEADLINE_LABEL = 5;
static const int const TAG_TYPEIMG_IMAGEVIEW = 6;


@interface ApproveListCell : UITableViewCell{
    
    UILabel *workflowNameLabel;
    UIView *alertBackgroundView;
    UILabel *currentStatusTextView;
    UILabel *commitDateTextView;
    UILabel *deadLineTextView;
    UIImageView *typeImg;
    
    Approve *_cellData;
}

@property (retain,nonatomic) Approve *cellData;

-(void)setCellData:(Approve *)approveEntity;

@end
