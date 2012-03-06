//
//  AuroraHTTPRequestDelegate.h
//  HRMS
//
//  Created by Rocky Lee on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuroraHTTPRequestDelegate.h"

@class AuroraHTTPRequest;

@protocol AuroraHTTPRequestDelegate <NSObject>

@optional
- (void)successSelector:(NSArray *)dataSet;

- (void)faildSelector:(NSString *)failedMessage;

- (void)errorSelector:(NSString *)errorSelector;

@end
