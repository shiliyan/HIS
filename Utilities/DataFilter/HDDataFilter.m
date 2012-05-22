//
//  HDDataParser.m
//  Three20Lab
//
//  Created by Rocky Lee on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDataFilter.h"

@implementation HDDataFilter

@synthesize nextFilter = _nextFilter;

-(id)initWithNextFilter:(id<HDDataFilter>) next
{
    if ([self init]) {
        self.nextFilter = next;
    }
    return self;
}

-(void)dealloc
{
    TT_RELEASE_SAFELY(_nextFilter);
    [super dealloc];
}

-(id)doFilter:(id)data error:(NSError **)error
{
    if (nil != data) {
        [self doNextFilter:data error:error];
    }
    [self errorWithData:data error:error];
    return nil;
}

-(id)doNextFilter:(id)data error:(NSError **)error
{
    //子类实现其转换过滤,然后调用父类方法
    id nextResult = nil;
    if (self.nextFilter) {
        nextResult = [self.nextFilter doFilter:data error:error];
    }else {
        nextResult = data;
    }
    if (nil != nextResult) {
        nextResult = [self afterDoNextFilter:(id)nextResult error:(NSError **)error];
    }
    if (nil != nextResult) {
        return nextResult;
    }
    [self errorWithData:data error:error];
    return nil;
}

-(id)afterDoNextFilter:(id)data error:(NSError **)error
{
    return data;
}

-(id)errorWithData:(id) data error:(NSError **)error
{
    if (error) {
        *error = [NSError errorWithDomain:kHDFilterErrorDomain
                                     code:kHDFilterErrorCode
                                 userInfo:[NSDictionary dictionaryWithObject:[data valueForKeyPath:@"error.message"] forKey:@"error"]];
    } 
    return nil; 
}
@end
