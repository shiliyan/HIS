//
//  HDApproveDetailDelegate.h
//  hrms
//
//  Created by Rocky Lee on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HDApproveDetailDelegate <NSObject>

-(void) webPageLoad:(ASIHTTPRequest*) theRequest responseString:(NSString *) htmlString;

-(void) actionLoad:(NSArray *) dataSet;

@end
