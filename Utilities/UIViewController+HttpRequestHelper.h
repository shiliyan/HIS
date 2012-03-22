//
//  UIViewController+HttpRequestHelper.h
//  LoginDemo
//
//  Created by Stone Lee on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HDFormDataRequest.h"
#import "ASIWebPageRequest.h"
#import "ASIDownloadCache.h"

@interface UIViewController (HttpRequestHelper)

-(void)formRequest:(NSString *) newURL 
          withData:(id) dic 
   successSelector:(SEL) successSelector 
    failedSelector:(SEL) failedSelector
     errorSelector:(SEL) errorSelector
 noNetworkSelector:(SEL) noNetworkSelector;

-(ASIWebPageRequest *) webPageRequestConfig:(ASIWebPageRequest *) webPageRequest
                                        url:(NSString *) theURL
                              loadSucceeded:(SEL) scuccessSelector
                                 loadFailed:(SEL) failedSelector;

@end
