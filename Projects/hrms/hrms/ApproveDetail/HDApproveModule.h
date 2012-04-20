//
//  HDApproveDetail.h
//  hrms
//
//  Created by Rocky Lee on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDBaseApproveModule.h"
#import "Approve.h"

@interface HDApproveModule : HDBaseApproveModule

@property (nonatomic,retain) Approve * approveEntity;

-(id) initWithApproveModule:(Approve *) approve;

-(void)saveApprove;

@end
