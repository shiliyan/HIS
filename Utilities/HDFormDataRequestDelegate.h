//
//  AuroraHTTPRequestDelegate.h
//  HRMS
//
//  Created by Rocky Lee on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDFormDataRequestDelegate.h"
#import "ASIFormDataRequest.h"

@class HDFormDataRequest;

@protocol HDFormDataRequestDelegate <NSObject>

@required
- (void)requestSuccess:(ASIFormDataRequest *) request  dataSet:(NSArray *)dataSet;

@optional
- (void)requestServerError:(ASIFormDataRequest *) request errorMessage:(NSString *) message;

- (void)requestError:(ASIFormDataRequest *)request errorMessage: (NSString *) message;

- (void)requestAsiFaild:(ASIFormDataRequest *) request errorMessage: (NSString *) message;

@end
