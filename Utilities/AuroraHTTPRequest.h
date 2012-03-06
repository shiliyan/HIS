//
//  AuroraRequest.h
//  HRMS
//
//  Created by Rocky Lee on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

#import "AuroraHTTPRequestDelegate.h"


@interface AuroraHTTPRequest : ASIFormDataRequest{
    id <AuroraHTTPRequestDelegate> auroraDelegate;
}

@property (assign) SEL successSelector;
@property (assign) SEL faildSelector;
@property (assign) SEL errorSelector;
@property (assign) id  auroraDelegate;

+(id)requestWithURL:(NSURL*)url;

+(id)requestWithURL:(NSURL *)newURL usingCache:(id <ASICacheDelegate>)cache;

+(id)requestWithURL:(NSURL *)newURL usingCache:(id <ASICacheDelegate>)cache andCachePolicy:(ASICachePolicy)policy;

-(id)initWithURL:(NSURL *)newURL;

-(void)setPostParameter :(NSDictionary *) para;

@end
