//
//  HDApproveDetail.m
//  hrms
//
//  Created by Rocky Lee on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDApproveModule.h"
#import "HDURLCenter.h"

@implementation HDApproveModule

@synthesize approveEntity = _approveEntity;

-(id) initWithApproveModule:(Approve *) approve
{
    self = [super init];
    if (self) {
        self.approveEntity = approve;
        NSString * screenUrl = [NSString stringWithFormat:@"%@%@?record_id=%@",[HDURLCenter requestURLWithKey:@"APPROVE_SCREEN_BASE_PATH"],[_approveEntity screenName],[_approveEntity recordID]];  
        NSLog(@"%@",screenUrl);
        self.webPageURL = screenUrl;
    }
    return self;
}

-(void)beforeLoadActions:(HDBaseActions *)actionModule
{
    NSDictionary * parameter = [NSDictionary dictionaryWithObject:[_approveEntity recordID] 
                                                           forKey:@"record_id"];
    [actionModule setActionLoadParameters:parameter];
}

//-(void)startLoad
//{
//    //如果记录状态是等待,不加载动作    
//}

//审批
-(void)approve
{
}

@end
