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

@implementation HDFormDataRequest

//业务状态回调函数
@synthesize successSelector;
@synthesize serverErrorSelector;
@synthesize errorSelector;
@synthesize failedSelector;

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
//    NSLog(@"%@",newURL);
    
    HDFormDataRequest * request = [[[HDFormDataRequest alloc]initWithURL:[NSURL URLWithString:newURL]] autorelease];    
    
    [request setRequestPattern:requestPattern];
    [request setPostParameter:data];
    [request setRequestHeader];
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

-(id)setRequestHeader
{
    NSArray * cookies =  [[NSHTTPCookieStorage sharedHTTPCookieStorage]cookies];
    
    NSMutableDictionary * header =   [NSMutableDictionary dictionary];
    
    for (NSHTTPCookie * cookie in cookies) {
        [header setValue:[cookie value] forKey:[cookie name]];
        //        NSLog(@"%@",[cookie value]);
    }
    [self setRequestHeaders:header];
    return  self;
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
    return HD_JSON_STRING([NSDictionary dictionaryWithObject:(data == nil ? @"": data) 
                                                      forKey:@"parameter"]);
}

//包装返回数据
-(id) generateDataSet:(NSDictionary *)jsonData
{
    //把json包装成dataSet
    NSMutableArray * dataSet = nil;
    id datas = [jsonData valueForKeyPath:@"result.record"]; 
    if (nil == datas) {
        datas = [jsonData valueForKey:@"result"];
        if([[datas allKeys] count]!= 0){
            dataSet = [NSMutableArray arrayWithObject:datas];
        }
    }else{
        /*
         * debug:对请求bm的单条记录包装成数组 
         * Aor 12 2012
         */
        if ([datas isKindOfClass:[NSArray class]]) {
            dataSet = datas;
        }else {
            dataSet = [NSMutableArray arrayWithObject:datas];
        }
        
    }
    return dataSet;
}

#pragma -mark callback functions
//通信成功回调函数，根据也会返回状态调用不同的函数，成功后返回一个类似与dataSet的数组
-(void)requestFetchSuccess:(ASIHTTPRequest *)theRequest
{
//    NSLog(@"HDFormDataRequest.m -139 line \n\n%@",[theRequest responseString]);
    /*
     * debug:加入返回状态的判断，状态200才进行解析 
     * Mar 22 2012
     */
    if ([theRequest responseStatusCode] == 200) {
        //转换json数据为对象
        id JSONObj = HD_JSON_OBJECT([theRequest responseData]);

        //返回状态为成功
        if ([[JSONObj valueForKey:@"success"] boolValue]) {
            [self callRequestSuccess:theRequest withJSONObj:JSONObj];
        }else{
            //返回状态为error
            if ([JSONObj valueForKey:@"error"] != nil) {
                [self callRequestError:theRequest withJSONObj:JSONObj];
            }
        }
    }else {
        [self callRequestServerError:theRequest];
    }
}

//ASI定义的网络链接失败
-(void)requestFetchFailed:(ASIHTTPRequest *)theRequest
{
    //创建错误信息字典 
    NSString * errorCode = [NSString stringWithFormat:@"%i",[[theRequest error] code]];
    NSString * errorMessage = [[theRequest error]localizedDescription];
    NSDictionary * errorObject = [NSDictionary dictionaryWithObjectsAndKeys:errorCode,ERROR_CODE,errorMessage,ERROR_MESSAGE, nil];
    
    
    SEL function = [HDFunctionUtil matchPerformDelegate:hdFormDataRequestDelegate forSelectors:failedSelector,@selector(requestASIFailed:failedMessage:), nil];
    if (function !=nil) {
        [hdFormDataRequestDelegate performSelector:function
                                        withObject:theRequest
                                        withObject:errorObject];
    }else {
        NSLog(@"ASI网络错误,超时或无法找到服务器");
    }    
}

#pragma call selectors
-(void)callRequestSuccess:(ASIHTTPRequest *) theRequest withJSONObj:(id) JSONObj
{
    //把json包装成dataSet
    NSMutableArray * dataSet = [self generateDataSet:JSONObj];
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

-(void)callRequestError:(ASIHTTPRequest *)theRequest withJSONObj:(id) JSONObj
{
    //TODO:session超时的code是什么?固定?处理session超时错误
    NSString * errorCode = [JSONObj valueForKeyPath:@"error.code"];
    if ([errorCode isEqual:@"login_required"]) {
        //TODO:退回到登陆界面,这里时机可能有问题,此时视图可能在跳转中,会打断返回登录,应该由视图控制器控制跳转?
        [[NSNotificationCenter defaultCenter] postNotificationName:@"show_login_view" object:nil];
        return;
    }
    
    //执行错误的回调
    SEL function = [HDFunctionUtil matchPerformDelegate:hdFormDataRequestDelegate forSelectors:errorSelector,@selector(requestServerError:error:), nil];
    if (function !=nil) {
        [hdFormDataRequestDelegate performSelector:function
                                        withObject:theRequest
                                        withObject:[JSONObj valueForKey:@"error"]];
    }else {
        NSLog(@"Aurora的错误消息");
    }
}

-(void)callRequestServerError:(ASIHTTPRequest *)theRequest
{
    //返回状态为200 以外的状态
    //创建错误返回字典
    NSNumber * statusCode  = [NSString stringWithFormat:@"%i",[theRequest responseStatusCode]];
    NSDictionary * errorObject = 
    [NSDictionary dictionaryWithObjectsAndKeys:statusCode,ERROR_CODE,
                                  [theRequest responseStatusMessage],ERROR_MESSAGE,
                                  nil];
    
    
    SEL function = [HDFunctionUtil matchPerformDelegate:hdFormDataRequestDelegate forSelectors:serverErrorSelector,@selector(requestServerError:errorMessage:), nil];
    if (function !=nil) {
        [hdFormDataRequestDelegate performSelector:function
                                        withObject:theRequest
                                        withObject:errorObject];
    }else {
        NSLog(@"调用默认的回调,状态不是200,服务器错误");
    }
    
}

@end
