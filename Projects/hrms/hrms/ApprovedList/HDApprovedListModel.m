////
////  ApprovedListModel.m
////  hrms
////
////  Created by Rocky Lee on 5/7/12.
////  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
////
//
//#import "HDApprovedListModel.h"
//#import "HDURLCenter.h"
//@implementation HDApprovedListModel
//@synthesize request = _request;
//@synthesize delegate;
//
//-(void)dealloc
//{
//    TT_RELEASE_SAFELY(_request);
//    [super dealloc];
//}
//
//-(void)loadApprovedList
//{
//    NSString * queryUrl = [HDURLCenter requestURLWithKey:@"APPROVED_LIST_QUERY_PATH"];
//    self.request = [HDFormDataRequest hdRequestWithURL:queryUrl withData:nil pattern:HDrequestPatternNormal];
//    [_request setDelegate:self];
//    [_request setSuccessSelector:@selector(approvedListLoadSuccess:dataSet:)];
//    [_request setFailedSelector:@selector(approvedListLoadError:error:)];
//    [_request setServerErrorSelector:@selector(approvedListLoadError:error:)];
//    [_request setErrorSelector:@selector(approvedListLoadError:error:)];
//    [_request startAsynchronous];
//}
//
//
//- (void)approvedListLoadSuccess:(ASIHTTPRequest *) request dataSet:(NSArray *)dataSet
//{
//    [delegate performSelector:@selector(loadSuccess:)
//                   withObject:dataSet];
//}
//
//- (void)approvedListLoadError:(ASIHTTPRequest *)request error: (NSDictionary *)errorObject
//{    
//    //    [errorObject valueForKey:@"code"];
//    NSString * errorMessage =  [errorObject valueForKey:ERROR_MESSAGE]; 
//    [delegate performSelector:@selector(loadFailed:)
//                   withObject:errorMessage];
//}
//
//@end
