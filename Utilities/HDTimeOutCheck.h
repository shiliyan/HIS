//
//  HDTimeOutCheck.h
//  hrms
//
//  Created by Rocky Lee on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@interface HDTimeOutCheck : TTURLRequestModel

@property(nonatomic,readonly) BOOL isTimeOut;

+(BOOL)isTimeOut;

@end
