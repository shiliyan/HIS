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

static const int const WORKFLOW_TEXTVIEW_TAG = 1;
static const int const CURRENTSTATUS_TEXTVIEW_TAG = 2;
static const int const APPLICANT_TEXTVIEW_TAG = 3;
static const int const COMMITDATE_TEXTVIEW_TAG = 4;
static const int const DEADLINE_TEXTVIEW_TAG = 5;
static const int const TYPEIMG_IMAGEVIEW_TAG = 6;


@interface ApproveListCell : UITableViewCell{
    Approve *approveData;
    
    UILabel *workflowTextView;
    UILabel *currentStatusTextView;
    UILabel *applicantTextView;
    UILabel *commitDateTextView;
    UILabel *deadLineTextView;
    UIImageView *typeImg;
    
}

@property (retain, nonatomic)Approve *approveData;

-(void)setCellData:(Approve *)approveEntity;
@end
