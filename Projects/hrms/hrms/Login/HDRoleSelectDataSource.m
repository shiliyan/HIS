//
//  TTRoleSelectDataSource.m
//  hrms
//
//  Created by Rocky Lee on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDRoleSelectDataSource.h"
#import "HDDataJSONFilter.h"
#import "HDDataAuroraFilter.h"
#import "HDURLCenter.h"

static NSString * kRoleListQueryPath= @"ROLE_LIST_QYERY_PATH";

@implementation HDRoleSelectModel
@synthesize roleList = _roleList;
@synthesize isLoadedRole = _isLoadedRole;
@synthesize isSelectedRole = _isSelectedRole;

-(id)init
{
    if (self = [super init]) {
        _isLoadedRole = NO;
        _isSelectedRole = NO;
    }
    return self;
}

-(void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more
{
    if (_isLoadedRole) {
        [self selectRole];
    }if (!_isLoadedRole) {
        [self loadRoleList];
    }
    
}
-(void)selectRole
{
    TTDPRINT(@"selected role");
    //发起角色选择请求
}

-(void) loadRoleList
{
    NSString * queryUrl = [HDURLCenter requestURLWithKey:@"ROLE_LIST_QYERY_PATH"];
    
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
    //如果列表已经加载,做选择操作
    if (_isLoadedRole) {
        id _selectResult = [jsonParser doFilter:response.data error:&error];
        if (!_selectResult) {
            [self didFailLoadWithError:error];
            return;
        }
        _isSelectedRole = YES;  
    }
    //如果列表没有加载,加载列表
    if (!_isLoadedRole) {
        _roleList = [jsonParser doFilter:response.data error:&error];
        if (!_roleList) {
            [self didFailLoadWithError:error];
            return;
        }
        _isLoadedRole = YES;
    }
    
    [jsonParser release];
    [super requestDidFinishLoad:request];          
    
}

-(void)request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error
{
    TTDPRINT(@"request failed");
    [self didFailLoadWithError:error];
}

@end


@implementation HDRoleSelectDataSource
@synthesize roleSelectModel = _roleSelectModel;

- (id)init
{
    self = [super init];
    if (self) {
        _roleSelectModel = [[HDRoleSelectModel alloc]init];
        self.model = _roleSelectModel;
    }
    return self;
}

-(void)dealloc
{
    TT_RELEASE_SAFELY(_roleSelectModel);
    [super dealloc];
}

-(void)tableViewDidLoadModel:(UITableView *)tableView
{
    self.items = [NSMutableArray array];
    for (id role in _roleSelectModel.roleList) {
        [self.items addObject:
         [TTTableSummaryItem itemWithText:[role valueForKey:@"role_description"]]];
    }
}

-(id<TTModel>)model
{
    return _roleSelectModel;
}

@end
