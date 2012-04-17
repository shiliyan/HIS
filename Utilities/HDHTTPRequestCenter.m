//
//  HDHTTPRequestCenter.m
//  hrms
//
//  Created by Rocky Lee on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDHTTPRequestCenter.h"
#import "HDRequestConfigMap.h"
#import "ASIDownloadCache.h"
#import <objc/runtime.h>

@implementation HDHTTPRequestCenter

static HDHTTPRequestCenter * _requestCenter = nil;

@synthesize requestConfigMap = _requestConfigMap;


+(id)shareHTTPRequestCenter
{
    @synchronized(self){
        if (_requestCenter == nil) {
            _requestCenter = [[self alloc] init];
        }
    }
    return  _requestCenter;
}

+(id) allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (_requestCenter == nil) {
            _requestCenter = [super allocWithZone:zone];
            return  _requestCenter;
        }
    }
    return nil;
}

-(id)init
{
    self = [super init];
    if (self) {
        _requestConfigMap = [[HDRequestConfigMap alloc]init];
    }
    return self;
}

-(void)dealloc
{
    TT_RELEASE_SAFELY(_requestConfigMap)
    [super dealloc];
}

//根据指定delegate号码创建请求 
-(id)requestWithURL:(NSString *)newURL
        requestType:(HDRequestType) requestType
             forKey:(id)requestConfigKey
{
    return [self requestWithURL:newURL 
                       withData:nil
                    requestType:requestType 
                         forKey:requestConfigKey];
}

-(id)requestWithKey:(id)requestConfigKey 
        requestType:(HDRequestType)requestType
{
    HDRequestConfig * config = [self.requestConfigMap configForKey:requestConfigKey];
    
    return [self requestWithURL:[config requestURL] 
                       withData:[config requestData] 
                    requestType:requestType
                         forKey:requestConfigKey];
}

//根据传入参数生成request
-(id)requestWithURL:(NSString *)newURL 
           withData:(id) data 
        requestType:(HDRequestType) requestType
             forKey:(id)requestConfigKey
{
    
    switch (requestType) {
        case HDRequestTypeFormData:
        {
            HDRequestConfig * config = [self.requestConfigMap configForKey:requestConfigKey];
            HDFormDataRequest * theRequest = [HDFormDataRequest hdRequestWithURL:newURL
                                                                    withData:data
                                                                         pattern:HDrequestPatternNormal];


            //TODO:动态获取属性列表
//            NSLog(@"%@",[[config class] classFallbacksForKeyedArchiver]);
//            id LenderClass  = [[config class] description];
//            unsigned int outCount, i;
//            objc_objectptr_t * properties = class_copyPropertyList(LenderClass, &outCount);
//            for (i = 0; i < outCount; i++) {
//                objc_objectptr_t property = properties[i];
//                NSLog(@"%@",[NSString stringWithFormat:@"%s",property_getName(property)]);
//             fprintf(stdout, "%s %s\n", property_getName(property),property_getAttributes(property));
//            }
            
//            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                  config.delegate,@"delegate",
//                                  config.successSelector,@""
//                                  nil]
//            [theRequest setValuesForKeysWithDictionary:@"successSelector"];
            
            [theRequest setDelegate:config.delegate];
            [theRequest setSuccessSelector:config.successSelector];
            [theRequest setErrorSelector:config.errorSelector];
            [theRequest setServerErrorSelector:config.serverErrorSelector];
            [theRequest setFailedSelector:config.ASIDidFailSelector];  
            
            [theRequest setTag:config.tag];
            return theRequest;
            break;
        }
            
        case ASIRequestTypeWebPage:
        {
            HDRequestConfig * config = [self.requestConfigMap configForKey:requestConfigKey];
            ASIWebPageRequest * theRequest = [ASIWebPageRequest requestWithURL:[NSURL URLWithString:newURL]];
            [theRequest setDelegate:config.delegate];
            [theRequest setDidFinishSelector:config.ASIDidFinishSelector];
            [theRequest setDidFailSelector:config.ASIDidFailSelector];
            
            [theRequest setUrlReplacementMode:ASIReplaceExternalResourcesWithData];
            [theRequest setDownloadCache:[ASIDownloadCache sharedCache]];
            [theRequest setCachePolicy:ASIUseDefaultCachePolicy];
            
            [theRequest setDownloadDestinationPath:[[ASIDownloadCache sharedCache] pathToStoreCachedResponseDataForRequest:theRequest]];
            [[ASIDownloadCache sharedCache] setShouldRespectCacheControlHeaders:NO];
            
            return theRequest;
        }    
        default:
            break;
    }
    
}

@end
