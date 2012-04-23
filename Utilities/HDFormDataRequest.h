//
//  AuroraRequest.h
//  HRMS
//
//  Created by Rocky Lee on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

typedef enum {
    HDrequestPatternNormal = 0,
} HDrequestPattern;

static  NSString * ERROR_CODE = @"code";
static  NSString * ERROR_MESSAGE = @"message";

@protocol HDFormDataRequestDelegate;

@interface HDFormDataRequest : ASIFormDataRequest{
    id <HDFormDataRequestDelegate> hdFormDataRequestDelegate;
}

@property (assign) SEL successSelector;
@property (assign) SEL serverErrorSelector;
@property (assign) SEL errorSelector;
@property (assign) SEL failedSelector;

+(id)hdRequestWithURL:(NSString *)newURL
              pattern:(HDrequestPattern) requestPattern;

+(id)hdRequestWithURL:(NSString *)newURL 
             withData:(id) data
              pattern:(HDrequestPattern) requestPattern;

//请求回调的响应delegate 
-(id)delegate;

-(id)setDelegate:(id)newDelegate;

-(id)initWithURL:(NSURL *)newURL;

//设置提交参数
-(id)setPostParameter :(id) data;

@end

@protocol HDFormDataRequestDelegate <NSObject>

@required
- (void)requestSuccess:(ASIFormDataRequest *) request  dataSet:(NSArray *)dataSet;

@optional
- (void)requestServerError:(ASIFormDataRequest *) request error:(NSDictionary *) errorObject;

- (void)requestError:(ASIFormDataRequest *)request error: (NSDictionary *) errorObject;

- (void)requestASIFailed:(ASIFormDataRequest *) request error: (NSDictionary *) errorObject;

@end
