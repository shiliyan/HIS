//
//  ApproveListDetailController.m
//  Approve
//
//  Created by mas apple on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ApproveListDetailController.h"

@implementation ApproveListDetailController
@synthesize label;
@synthesize data;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    self.label.text = data.applicant;
}

-(void)dealloc{
    [super dealloc];
    data = nil;
}
@end
