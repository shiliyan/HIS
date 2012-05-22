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

static NSString * kAppreovedListQueryPath = @"APPROVED_LIST_QUERY_PATH";

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
    if (more) {
        _pageNum ++;
        _isLoadingMore = more;
    }
    NSString * queryUrl = [HDURLCenter requestURLWithKey:kAppreovedListQueryPath query:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%i",_pageNum],@"pageNum", nil]];
    
    TTURLRequest * request = [[HDHTTPRequestCenter shareHTTPRequestCenter]requestWithKey:nil requestType:TTRequest];
    request.urlPath = queryUrl;
    [request.delegates addObject:self];
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
        
        if ([self isLoadingMore]) {
            NSMutableArray * moreArray = [_approvedList mutableCopy];
            [moreArray addObjectsFromArray:tempApproveList];
            [tempApproveList release];
            TT_RELEASE_SAFELY(_approvedList);
            _approvedList = moreArray;
            _isLoadingMore = NO;
        }else {
            TT_RELEASE_SAFELY(_approvedList);
            _approvedList = tempApproveList;
        }
        
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
         [TTTableMessageItem  itemWithTitle:approvedRecord.orderType  
                                    caption:approvedRecord.workflowName                                
                                       text:textContent 
                                  timestamp:nil
                                        URL:screenUrl]];
    }
    [self.items addObject:[TTTableMoreButton itemWithText:@"更多..."]];
}

-(id<TTModel>)model
{
    return _approvedListModel;
}

@end
