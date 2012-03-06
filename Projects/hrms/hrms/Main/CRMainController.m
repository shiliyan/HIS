//
//  CRMainController.m
//  HRMS
//
//  Created by Rocky Lee on 3/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CRMainController.h"

@implementation CRMainController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTabURLs:[NSArray arrayWithObjects:
                      @"tt://aprove",
//                      @"tt://menu/1",
//                      @"tt://menu/2",
//                      @"tt://menu/3",
//                      @"tt://menu/4",  
                      @"tt://preferences/1",
                      nil]];
    // Do any additional setup after loading the view from its nib.
}

@end
