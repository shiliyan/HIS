//
//  HDResourceLoader.m
//  hrms
//
//  Created by Rocky Lee on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDResourceCenter.h"

static NSString * kLoginBackGroundImagePath = @"LOGIN_BACKGROUND_IMAGE_PATH";

@implementation HDResourceCenter

+(void)load
{
    HDResourceCenter * center = [[HDResourceCenter alloc]init];
    [center load:TTURLRequestCachePolicyNetwork more:NO];
    TT_RELEASE_SAFELY(center);
}

+(NSString *)filePathWithFileName:(NSString *)fileName
{
    NSArray * paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) autorelease];
    NSString * documentsDicrectory = [paths objectAtIndex:0];
    return [documentsDicrectory stringByAppendingPathComponent:fileName];
}

-(void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more
{
    NSString * imagePath = [HDResourceCenter filePathWithFileName:@"login.png"];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    if ([fileManager isReadableFileAtPath:imagePath]) {
        NSError * error = nil;
        [fileManager removeItemAtPath:imagePath error:&error];
    }
    
    NSString * queryUrl = [HDURLCenter requestURLWithKey:kLoginBackGroundImagePath];
    TTURLRequest * request = [TTURLRequest requestWithURL:queryUrl delegate:self];
    request.response = [[[TTURLDataResponse alloc]init]autorelease];
    [request send];
}

-(void)requestDidFinishLoad:(TTURLRequest *)request
{
    TTURLDataResponse * response = request.response;
    if (nil != response.data) {
        [response.data writeToFile:[HDResourceCenter filePathWithFileName:@"login.png"] atomically:YES];
    }
    [super requestDidFinishLoad:request];
}
@end
