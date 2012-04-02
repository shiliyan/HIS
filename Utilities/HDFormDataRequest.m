//
//  AuroraRequest.m
//  HRMS
//
//  Created by Rocky Lee on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDFormDataRequest.h"
#import "HDFunctionUtil.h"
#import "HDConvertUtil.h"

@interface HDFormDataRequest()

//设置请求模式，例如cookies之类的默认模式
//-(id)setRequestPattern:(HDrequestPattern) requestPattern;
//默认的错误回调函数
//-(void) aruoraRequestError:(NSString *) errorMessage withRequest:(ASIHTTPRequest *) request;
@end

@implementation HDFormDataRequest

//业务状态回调函数
@synthesize successSelector;
@synthesize serverErrorSelector;
@synthesize errorSelector;
@synthesize asiFaildSelector;

#pragma -mark initializtion
-(id)initWithURL:(NSURL *)newURL
{
    self = [super initWithURL:newURL];
    [self setDidFinishSelector:@selector(requestFetchSuccess:)];
    [self setDidFailSelector:@selector(requestFetchFailed:)];
    [super setDelegate:self];
    return self;
}

+(id)hdRequestWithURL:(NSString *)newURL 
              pattern:(HDrequestPattern) requestPattern;
{
    return [self hdRequestWithURL:newURL 
                         withData:nil 
                          pattern:requestPattern];
}

+(id)hdRequestWithURL:(NSString *)newURL 
             withData:(id) data
              pattern:(HDrequestPattern) requestPattern
{
    HDFormDataRequest * request = [[[HDFormDataRequest alloc]initWithURL:[NSURL URLWithString:newURL]] autorelease];    
    
    [request setRequestPattern:requestPattern];
    [request setPostParameter:data];
    return request;
}

-(void)dealloc{
    hdFormDataRequestDelegate = nil;
    [super dealloc];
}

#pragma -mark 设置请求模式，例如cookies之类的默认模式
-(id)setRequestPattern:(HDrequestPattern) requestPattern{
    switch (requestPattern) {
        case 0:
            //set cookies
            [self setUseCookiePersistence:YES];
            [self setRequestCookies:[NSMutableArray arrayWithArray:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]]];
            //            [self setResponseEncoding:NSUTF8StringEncoding];
            return self;
            break;
            
        default:
            return self;
            break;
    }
    /*
     *debug:设置默认的return　NO,调用时的警告可能和这个有关系
     */
    NSLog(@"提交模式设置错误");
    return self;
}


#pragma -mark 设置回调函数delegate,因为父类存在一个delegate,这里手写存取器方法，设置父类的delegate和本类的delegate

- (id)delegate
{
    return hdFormDataRequestDelegate;
}

- (id)setDelegate:(id)newDelegate
{
    hdFormDataRequestDelegate = newDelegate;
    return self;
}

-(id)setPostParameter :(id) data
{
    [self setPostValue:[self generatePostData:data] 
                forKey:@"_request_data"];
    return self;
}

//包装请求参数
-(id) generatePostData:(id)data
{   
    return HD_JSON_STRING([NSDictionary dictionaryWithObject:HD_NVL(data, @"") 
                                                      forKey:@"parameter"]);
}

//包装返回数据
-(id) generateDataSet:(NSDictionary *)jsonData
{
    //把json包装成dataSet
    NSMutableArray * dataSet;
    id datas = [[jsonData valueForKey:@"result"]objectForKey:@"record"]; 
    
    if (datas == nil) {
        datas = [jsonData valueForKey:@"result"];
        dataSet = [NSMutableArray arrayWithObject:datas];
    }else{
        dataSet = datas;
    }
    
    return dataSet;
}

#pragma -mark callback functions
//通信成功回调函数，根据也会返回状态调用不同的函数，成功后返回一个类似与dataSet的数组
-(void)requestFetchSuccess:(ASIHTTPRequest *)theRequest
{
    //      NSLog(@"HDFormDataRequest.m -107 line \n\n%@",[theRequest responseString]);
    /*
     * debug:加入返回状态的判断，状态200才进行解析 
     * Mar 22 2012
     */
    if ([theRequest responseStatusCode] == 200) {
        //转换json数据为对象
        id jsonData = HD_JSON_OBJECT([theRequest responseString]);
        //返回状态为成功
        if ([[jsonData valueForKey:@"success"]boolValue]) {
            [self callRequestSuccess:theRequest];
        }else{
            //返回状态为error
            if ([jsonData valueForKey:@"error"] != nil) {
                [self callRequestError:theRequest];
            }
        }
    }else {
        [self callRequestServerError:theRequest];
    }
}

//网络链接失败，默认弹出alert
-(void)requestFetchFailed:(ASIHTTPRequest *)theRequest
{
    SEL function = [HDFunctionUtil matchPerformDelegate:hdFormDataRequestDelegate forSelectors:asiFaildSelector,@selector(requestAsiFaild:errorMessage:), nil];
    if (function !=nil) {
        [hdFormDataRequestDelegate performSelector:function
                                        withObject:theRequest
                                        withObject:[theRequest responseStatusMessage]];
    }else {
        NSLog(@"ASI网络错误,超时或无法找到服务器");
    }    
}



#pragma call selectors
-(void)callRequestSuccess:(ASIHTTPRequest *) theRequest
{
    id jsonData = HD_JSON_OBJECT([theRequest responseString]);
    //把json包装成dataSet
    NSMutableArray * dataSet = [self generateDataSet:jsonData];
    //执行成功回调

    SEL function = [HDFunctionUtil matchPerformDelegate:hdFormDataRequestDelegate 
                                           forSelectors:successSelector,@selector(requestSuccess:dataSet:), nil];
    if (function !=nil) {
        [hdFormDataRequestDelegate performSelector:function
                                        withObject:theRequest
                                        withObject:dataSet];
    }else {
        NSLog(@"成功的回调没有实现");
    }
}

-(void)callRequestError:(ASIHTTPRequest *)theRequest
{
    NSString * errorMessage = [[HD_JSON_OBJECT([theRequest responseString]) valueForKey:@"error"] valueForKey:@"message"];
    
    //执行错误的回调
    SEL function = [HDFunctionUtil matchPerformDelegate:hdFormDataRequestDelegate forSelectors:errorSelector,@selector(requestError:errorMessage:), nil];
    if (function !=nil) {
        [hdFormDataRequestDelegate performSelector:function
                                        withObject:theRequest
                                        withObject:errorMessage];
    }else {
        NSLog(@"Aurora的错误消息");
    }
}

-(void)callRequestServerError:(ASIHTTPRequest *)theRequest
{
    //返回状态为200 以外的状态 
    SEL function = [HDFunctionUtil matchPerformDelegate:hdFormDataRequestDelegate forSelectors:serverErrorSelector,@selector(requestServerError:errorMessage:), nil];
    if (function !=nil) {
        [hdFormDataRequestDelegate performSelector:function
                                        withObject:theRequest
                                        withObject:[theRequest responseStatusMessage]];
    }else {
        NSLog(@"调用默认的回调,状态不是200,服务器错误");
    }
    
}



@end
