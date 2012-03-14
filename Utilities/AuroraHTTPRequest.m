//
//  AuroraRequest.m
//  HRMS
//
//  Created by Rocky Lee on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AuroraHTTPRequest.h"

@interface AuroraHTTPRequest()
//-(void)requestFetchSuccess:(ASIHTTPRequest *)theRequest;
//默认的错误回调函数
-(void)aruoraRequestError:(NSString *) errorMessage;
//默认的失败回调函数
-(void)aruoraRequestFailed:(NSString *) failedMessage;
@end

@implementation AuroraHTTPRequest

//业务状态回调函数
@synthesize successSelector;
@synthesize faildSelector;
@synthesize errorSelector;
@synthesize auroraDelegate;

//TODO:构造函数，根据需要对请求参数进行默认定制
-(id)initWithURL:(NSURL *)newURL
{
    self = [super initWithURL:newURL];
    [self setDidFinishSelector:@selector(requestFetchSuccess:)];
    [self setDidFailSelector:@selector(requestFetchFailed:)];
    [self setDelegate:self];
    return self;
}

+(id)requestWithURL:(NSURL*)newURL
{
    return [[[self alloc] initWithURL:newURL] autorelease];
}

+(id)requestWithURL:(NSURL *)newURL usingCache:(id <ASICacheDelegate>)cache
{
	return [self requestWithURL:newURL usingCache:cache andCachePolicy:ASIUseDefaultCachePolicy];
}

+(id)requestWithURL:(NSURL *)newURL usingCache:(id <ASICacheDelegate>)cache andCachePolicy:(ASICachePolicy)policy
{
	AuroraHTTPRequest *request = [[[self alloc] initWithURL:newURL] autorelease];
	[request setDownloadCache:cache];
	[request setCachePolicy:policy];
	return request;
}

//为请求参数添加头
-(void) setPostParameter :(id) datas
{
    [self setPostValue:[[NSDictionary dictionaryWithObject:datas 
                                                    forKey:@"parameter"] JSONRepresentation] 
                forKey:@"_request_data"];
}

//通信成功回调函数，根据也会返回状态调用不同的函数，成功后返回一个类似与dataSet的数组
-(void)requestFetchSuccess:(ASIHTTPRequest *)theRequest
{
    //转换json数据为对象
//    NSLog(@"%@",[theRequest responseString]);
    id jsonData = [[theRequest responseString] JSONValue];
    BOOL successFlg = (BOOL)[jsonData valueForKey:@"success"];
    //返回状态为成功
    if (successFlg) {
        //把json包装成dataSet
        NSMutableArray * dataSet;
        id datas = [[jsonData valueForKey:@"result"]objectForKey:@"record"];        
        if (datas ==nil) {
            datas = [jsonData valueForKey:@"result"];
            dataSet = [NSMutableArray arrayWithObject:datas];
        }else{
            dataSet = datas;
        }
        
        if (auroraDelegate && [auroraDelegate respondsToSelector:successSelector]) {
            [auroraDelegate performSelector:successSelector withObject:dataSet];
        }
    }else{
        //返回状态为error
        id  errorObj = nil;
        errorObj = [jsonData valueForKey:@"error"];
        if (errorObj != nil) {
            NSString * errorMessage = [errorObj valueForKey:@"message"];
            if (auroraDelegate && [auroraDelegate respondsToSelector:errorSelector]) {
                [auroraDelegate performSelector:errorSelector withObject:errorMessage];
            }else{
                [self aruoraRequestError:errorMessage];
            }
        }
        //返回状态为failed
        id failedObj= nil;
        failedObj = [jsonData valueForKey:@"failed"];
        if (failedObj !=nil) {
            NSString * failedMessage = [failedObj valueForKey:@"message"];
            if (auroraDelegate && [auroraDelegate respondsToSelector:faildSelector]) {
                [auroraDelegate performSelector:faildSelector withObject:failedMessage];
            }else{
                [self aruoraRequestFailed:failedMessage];
            }
        }
    }
}

//网络链接失败，默认弹出alert
-(void)requestFetchFailed:(ASIHTTPRequest *)theRequest
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络连接失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    [alert release];
    
}

//aurora的失败消息默认函数，可以传入回调函数覆盖
-(void) aruoraRequestFailed:(NSString *) failedMessage
{
    NSLog(@"Aruora Request Failed");
    NSLog(@"%@",failedMessage);
}

//aurora框架的错误消息，可以传入回调函数覆盖
-(void) aruoraRequestError:(NSString *) errorMessage
{
    NSLog(@"Aruora Request Error");
    NSLog(@"%@",errorMessage);
}

@end
