//
//  AuroraRequest.h
//  HRMS
//
//  Created by Rocky Lee on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "HDFormDataRequestDelegate.h"

typedef enum {
    HDrequestPatternNormal = 0,
} HDrequestPattern;

@interface HDFormDataRequest : ASIFormDataRequest{
    id <HDFormDataRequestDelegate> hdFormDataRequestDelegate;
}

@property (assign) SEL successSelector;
@property (assign) SEL serverErrorSelector;
@property (assign) SEL errorSelector;
@property (assign) SEL asiFaildSelector;


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
