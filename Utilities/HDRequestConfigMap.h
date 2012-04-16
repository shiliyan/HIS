//
//  HDRequestDelegateMap.h
//  hrms
//
//  Created by Rocky Lee on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//请求配置
@interface HDRequestConfig : NSObject
{
    id <HDFormDataRequestDelegate,ASIHTTPRequestDelegate> delegate;

}
@property (nonatomic,retain) NSString *requestURL;
@property (nonatomic,retain) id requestData;
@property (nonatomic) NSUInteger tag;

@property (assign) id  delegate;
@property (assign) SEL successSelector;
@property (assign) SEL serverErrorSelector;
@property (assign) SEL errorSelector;
@property (assign) SEL failedSelector;

@property (assign) SEL ASIDidFinishSelector;
@property (assign) SEL ASIDidFailSelector;

@end

//请求配置表
@interface HDRequestConfigMap : NSObject
{
    @private
    NSMutableDictionary * _configMap;
}

-(void)addConfig:(HDRequestConfig *) config forKey:(id) theKey;

-(HDRequestConfig *) configForKey:(id) theKey;

-(void) removeConfigForKey:(id) theKey;

@end
