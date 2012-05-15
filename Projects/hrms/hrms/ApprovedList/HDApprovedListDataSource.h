//
//  ApprovedListDataSource.h
//  hrms
//
//  Created by Rocky Lee on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "Approve.h"

@interface HDApprovedListModel : TTURLRequestModel

//@property(nonatomic,retain) HDFormDataRequest * formRequest;
@property(nonatomic,readonly ) NSArray * approvedList;

@end

@interface HDApprovedListDataSource : TTListDataSource

@property(nonatomic,readonly) HDApprovedListModel * approvedList;

@end
