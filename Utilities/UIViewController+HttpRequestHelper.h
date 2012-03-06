//
//  UIViewController+HttpRequestHelper.h
//  LoginDemo
//
//  Created by Stone Lee on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "AuroraHTTPRequest.h"

@interface UIViewController (HttpRequestHelper)

-(void)formRequest:(NSURL*)url 
          withData:(NSDictionary *) dic 
   successSelector:(SEL) successSelector 
    failedSelector:(SEL) failedSelector
     errorSelector:(SEL) errorSelector;

@end
