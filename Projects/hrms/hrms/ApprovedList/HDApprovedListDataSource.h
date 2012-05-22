//
//  ApprovedListDataSource.h
//  hrms
//
//  Created by Rocky Lee on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "Approve.h"

@interface HDApprovedListModel : TTURLRequestModel

@property(nonatomic,readonly) NSArray * approvedList;
@property(nonatomic) NSUInteger pageNum;

- (void)search:(NSString*)text;

@end

@interface HDApprovedListDataSource : TTListDataSource

@property(nonatomic,readonly) HDApprovedListModel * approvedListModel;

@end
