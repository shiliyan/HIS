//
//  AuroraRequest.m
//  HRMS
//
//  Created by Rocky Lee on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDFormDataRequest.h"

@interface HDFormDataRequest()
//-(void)requestFetchSuccess:(ASIHTTPRequest *)theRequest;
//默认的错误回调函数
-(void)aruoraRequestError:(NSString *) errorMessage;
@end

@implementation HDFormDataRequest

//业务状态回调函数
@synthesize successSelector;
@synthesize serverErrorSelector;
@synthesize errorSelector;
@synthesize asiFaildSelector;

//TODO:构造函数，根据需要对请求参数进行默认定制
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
    HDFormDataRequest * request = [[HDFormDataRequest alloc]initWithURL:[NSURL URLWithString:newURL]];    
    
    [request setRequestPattern:requestPattern];
    //set post parameter
    if (data != nil) {
        [request setPostParameter:data];
    }
    return request;
}

-(void)dealloc{
    [super clearDelegatesAndCancel];
    auroraDelegate = nil;
    [super dealloc];
}

/*
 *设置请求模式，例如cookies之类的默认模式
 */
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
}

/*
 *设置回调函数delegate,因为父类存在一个delegate,这里手写存取器方法，设置父类的delegate和本类的delegate
 */
- (id)delegate
{
    return auroraDelegate;
}

- (void)setDelegate:(id)newDelegate
{
    auroraDelegate = newDelegate;
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
    //        NSLog(@"%@",[theRequest responseString]);
    //debug:加入返回状态的判断，状态200才进行解析
    if ([theRequest responseStatusCode] ==200) {
        id jsonData = [[theRequest responseString] JSONValue];
        BOOL successFlg = [[jsonData valueForKey:@"success"]boolValue];
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
            }else {
                NSLog(@"Aurora Request Success");
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
            
        }
    }else {
        //返回状态为200 以外的状态 
        if (auroraDelegate && [auroraDelegate respondsToSelector:serverErrorSelector]) {
            [auroraDelegate performSelector:serverErrorSelector withObject:theRequest];
        }else{
            [self requestFetchFailed:theRequest];
        }
    }
    
}

//网络链接失败，默认弹出alert
-(void)requestFetchFailed:(ASIHTTPRequest *)theRequest
{
    if (auroraDelegate && [auroraDelegate respondsToSelector:asiFaildSelector]) {
        [auroraDelegate performSelector:asiFaildSelector withObject:theRequest];
    }else{
        NSLog(@"ASI网络请求失败");
    }
    //    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"ASI" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    //    [alert show];
    //    [alert release];
    
}

//aurora框架的错误消息，可以传入回调函数覆盖
-(void) aruoraRequestError:(NSString *) errorMessage
{
    NSLog(@"Aruora Request Error");
    NSLog(@"%@",errorMessage);
}

@end
