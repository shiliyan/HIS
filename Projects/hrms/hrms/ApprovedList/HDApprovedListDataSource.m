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
@synthesize approvedList = _approvedList;
@synthesize pageNum = _pageNum;

-(id)init
{
    if (self = [super init]) {
        _pageNum = 1;
    }
    return self;
}

-(void)search:(NSString *)text
{
    [self cancel];
    TT_RELEASE_SAFELY(_approvedList);
    if (text.length) {
        [self.delegates performSelector:@selector(modelDidStartLoad:) withObject:self]; 
        [self.delegates performSelector:@selector(modelDidChange:) withObject:self];
    }
}

-(void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more
{
    NSString * queryUrl = [HDURLCenter requestURLWithKey:@"APPROVED_LIST_QUERY_PATH"];
    queryUrl = [NSString stringWithFormat:@"%@?pagesize=10&pagenum=%i&_fetchall=false&_autocount=false",queryUrl,_pageNum];

    TTURLRequest *request = [TTURLRequest requestWithURL:queryUrl delegate:self];
    
    request.cachePolicy = TTURLRequestCachePolicyNoCache;
    request.httpMethod = @"POST";
    request.multiPartForm = false;
    request.response = [[[TTURLDataResponse alloc]init] autorelease];
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
        NSArray * tempApproveList = [[[HDGodXMLFactory shareBeanFactory] beansWithArray:dataSet path:@"/service/field-mappings/field-mapping[@url_name='APPROVE_TABLE_QUERY_URL']"]retain] ;
        
//        NSMutableArray * tempApproveList = [NSMutableArray arrayWithCapacity:dataSet.count];
//        for (id record in dataSet) {
//            [tempApproveList addObject:[[[Approve alloc]initWithDictionary:record] autorelease]];
//        }
//        if (nil!= _approvedList && _approvedList.count > 0) {
//            [tempApproveList insertObjects:_approvedList atIndexes:0];
//        }
        _approvedList = tempApproveList;
        
        [self didFinishLoad];
        
        [super requestDidFinishLoad:request];          
    }
}

-(void)request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error
{
    [self didFailLoadWithError:error];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////
@implementation HDApprovedListDataSource
@synthesize approvedListModel = _approvedListModel;

- (id)init
{
    self = [super init];
    if (self) {
        _approvedListModel = [[HDApprovedListModel alloc]init];
        self.model = _approvedListModel;
    }
    return self;
}

-(void)dealloc
{
    TT_RELEASE_SAFELY(_approvedListModel);
    [super dealloc];
}

-(void)tableViewDidLoadModel:(UITableView *)tableView
{
    self.items = [NSMutableArray array];
    for (Approve * approvedRecord in _approvedListModel.approvedList) {
        NSString * textContent = [NSString stringWithFormat:@"%@ %@",
                                  (nil == approvedRecord.statusName)?@"":approvedRecord.statusName,
                                  (nil ==approvedRecord.instanceDesc)?@"":approvedRecord.instanceDesc];
        NSString * screenUrl =  
        [NSString stringWithFormat:@"%@?doc_page_url=%@&instance_id=%@",
         [HDURLCenter requestURLWithKey:@"APPROVE_DETIAL_WEB_PAGE_PATH"],
         approvedRecord.docPageUrl,
         approvedRecord.instanceId];
        
        [self.items addObject:
         [TTTableMessageItem itemWithTitle:approvedRecord.orderType  
                                   caption:approvedRecord.workflowName                                
                                      text:textContent 
                                 timestamp:nil
                                  imageURL:nil 
                                       URL:screenUrl]];
    }
}

-(id<TTModel>)model
{
    return _approvedListModel;
}

@end
