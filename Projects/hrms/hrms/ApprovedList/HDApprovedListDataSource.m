//
//  ApprovedListDataSource.m
//  hrms
//
//  Created by Rocky Lee on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDApprovedListDataSource.h"
#import "HDURLCenter.h"
#import "HDDataAuroraFilter.h"
#import "HDDataJSONFilter.h"

@implementation HDApprovedListModel
//@synthesize formRequest = _formRequest;
@synthesize approvedList = _approvedList;

-(void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more
{
    NSString * queryUrl = [HDURLCenter requestURLWithKey:@"APPROVED_LIST_QUERY_PATH"];
    //    self.formRequest = [HDFormDataRequest hdRequestWithURL:queryUrl withData:nil pattern:HDrequestPatternNormal];
    //    [_formRequest setDelegate:self];
    //    [_formRequest setSuccessSelector:@selector(approvedListLoadSuccess:dataSet:)];
    //    [_formRequest setFailedSelector:@selector(approvedListLoadError:error:)];
    //    [_formRequest setServerErrorSelector:@selector(approvedListLoadError:error:)];
    //    [_formRequest setErrorSelector:@selector(approvedListLoadError:error:)];
    //    [_formRequest startAsynchronous];
    TTURLRequest *request = [TTURLRequest requestWithURL:queryUrl delegate:self];
    
    request.cachePolicy = TTURLRequestCachePolicyNoCache;
    request.httpMethod = @"POST";
    request.multiPartForm = false;
    request.response = [[TTURLDataResponse alloc]init];
    [request send];
}

-(void)requestDidFinishLoad:(TTURLRequest *)request
{
    
    TTURLDataResponse * response = request.response;
    NSError *error =nil;
    
    HDDataFilter * dataParser = [[[HDDataAuroraResponseFilter alloc]initWithNextFilter:nil]autorelease];
    HDDataFilter * jsonParser = [[HDDataToJSONFilter alloc]initWithNextFilter:dataParser];
    
    NSArray * dataSet = [jsonParser doFilter:response.data error:&error];
    [jsonParser release];
    
    if (!dataSet) {
        [self didFailLoadWithError:error];
    }else {
        NSMutableArray * tempApproveList = [NSMutableArray arrayWithCapacity:dataSet.count];
        for (id record in dataSet) {
            [tempApproveList addObject:[[[Approve alloc]initWithDictionary:record] autorelease]];
        }
        _approvedList = [NSArray arrayWithArray:tempApproveList];
        [self didFinishLoad];
        
        [super requestDidFinishLoad:request];          
    }
}

-(void)request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error
{
    [self didFailLoadWithError:error];
}
//#pragma -mark HDFormRequest delegate functions
//-(void)approvedListLoadSuccess:(ASIFormDataRequest *)request dataSet:(NSArray *)dataSet
//{
//    NSMutableArray * tempApproveList = [NSMutableArray arrayWithCapacity:dataSet.count];
//    for (id record in dataSet) {
//         [tempApproveList addObject:[[[Approve alloc]initWithDictionary:record] autorelease]];
//    }
//    _approvedList = [NSArray arrayWithArray:tempApproveList];
//    [self didFinishLoad];
//}
//
//- (void)approvedListLoadError:(ASIFormDataRequest *)request error: (NSDictionary *) errorObject
//{
//    [self didFailLoadWithError:
//     [NSError errorWithDomain:request.domain
//                         code:request.responseStatusCode 
//                     userInfo:errorObject]];
//}

@end

@implementation HDApprovedListDataSource
@synthesize approvedList = _approvedList;

- (id)init
{
    self = [super init];
    if (self) {
        _approvedList = [[HDApprovedListModel alloc]init];
        self.model = _approvedList;
    }
    return self;
}

-(void)dealloc
{
    TT_RELEASE_SAFELY(_approvedList);
    [super dealloc];
}

-(void)tableViewDidLoadModel:(UITableView *)tableView
{
    self.items = [NSMutableArray array];
    for (Approve * approvedRecord in _approvedList.approvedList) {
        NSString * textContent = [NSString stringWithFormat:@"%@ %@",
                                  approvedRecord.statusName,
                                  approvedRecord.instanceDesc];
        NSString * screenUrl =  
        [NSString stringWithFormat:@"%@?doc_page_url=%@&instance_id=%@",
         [HDURLCenter requestURLWithKey:@"APPROVE_DETIAL_WEB_PAGE_PATH"],
         approvedRecord.screenName,
         approvedRecord.instanceId];
        
        [self.items addObject:[TTTableMessageItem itemWithTitle:approvedRecord.orderType  
                                                        caption:approvedRecord.workflowName           
                                                           text:textContent 
                                                      timestamp:nil
                                                       imageURL:nil 
                                                            URL:screenUrl]];
    }
}

-(id<TTModel>)model
{
    return _approvedList;
}

@end
