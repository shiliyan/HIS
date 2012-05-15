//
//  ApprovedListModel.h
//  hrms
//
//  Created by Rocky Lee on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//#import <Foundation/Foundation.h>
//
//@protocol ApprovedListDelegate;
//
//@interface HDApprovedListModel : NSObject
//
//@property(nonatomic,retain) HDFormDataRequest * request;
//@property(nonatomic,assign) id<ApprovedListDelegate> delegate;
//
//-(void)loadApprovedList;
//
//@end

@protocol ApprovedListDelegate <NSObject>

-(void)loadFailed:(NSString *) errorMessage;

-(void)loadSuccess:(NSArray *) dataSet;

@end