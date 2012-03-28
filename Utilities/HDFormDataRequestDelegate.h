//
//  AuroraHTTPRequestDelegate.h
//  HRMS
//
//  Created by Rocky Lee on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDFormDataRequestDelegate.h"
#import "HDFormDataRequest.h"

@class HDFormDataRequest;

@protocol HDFormDataRequestDelegate <NSObject>

@optional
- (void)successSelector:(id)dataSet  withRequest:(HDFormDataRequest *) request;

- (void)serverErrorSelector:(NSString *)serverErrorMessage theRequest:(HDFormDataRequest *) request;

- (void)errorSelector:(NSString *)errorMessage theRequest:(HDFormDataRequest *)request;

- (void)asiFaildSelector:(HDFormDataRequest *) theRequest;

@end
