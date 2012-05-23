//
//  HDAuroraDataParser.m
//  Three20Lab
//
//  Created by Rocky Lee on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDataAuroraFilter.h"

//请求过滤
@implementation HDDataAuroraRequestFilter

-(id)doFilter:(id)data error:(NSError **)error
{
    if ([data isKindOfClass:[NSDictionary class]]||
        [data isKindOfClass:[NSArray class]]) 
    {
        //包装到parameter中
        id parameterData = 
        [NSDictionary dictionaryWithObject:(data == nil ? @"": data) 
                                    forKey:@"parameter"];
        
        return [self doNextFilter:parameterData error:error];
    }
    
    return [self errorWithData:data error:error];   
}

-(id)afterDoNextFilter:(id)data error:(NSError **)error
{
    return [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] autorelease];
}

@end

//响应过滤
@implementation HDDataAuroraResponseFilter

-(id)doFilter:(id)data error:(NSError **)error
{
    if ([[data valueForKeyPath:@"success"] boolValue]) { 
        //重新组装数据为array-dictionary结构
        id dataSet = [data valueForKeyPath:@"result.record"]; 
        if (nil == dataSet) {
            //如果record节点没有数据,表示为单条记录,从result节点取数据,包装成array
            dataSet = [data valueForKey:@"result"];
            if(nil != dataSet){
                dataSet = [NSMutableArray arrayWithObject:dataSet];
            }
        }else{
            if (![dataSet isKindOfClass:[NSArray class]]) {
                dataSet = [NSMutableArray arrayWithObject:dataSet]; 
            }            
        }
        return [self doNextFilter:dataSet error:error];   
    }
    //失败处理
    return [self errorWithData:data error:error];
}

-(id)errorWithData:(id) data error:(NSError **)error
{
    if (error && !*error) {
        *error = [NSError errorWithDomain:kHDFilterErrorDomain
                                     code:kHDFilterErrorCode
                                 userInfo:[NSDictionary dictionaryWithObject:[data valueForKeyPath:@"error.message"] forKey:@"error"]];
    } 
    return nil; 
}
@end


