//
//  HDApprovedListSearchDataSource.m
//  hrms
//
//  Created by Rocky Lee on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDApprovedListSearchDataSource.h"

@implementation HDApprovedListSearchDataSource

-(void)search:(NSString *)text
{
    [self.approvedListModel search:text];
}


@end
