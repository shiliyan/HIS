//
//  HDDataParser.h
//  Three20Lab
//
//  Created by Rocky Lee on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@protocol HDDataFilter <NSObject>

//开始过滤
-(id)doFilter:(id)data error:(NSError **) error;

-(id)doNextFilter:(id)data error:(NSError **) error;

//执行完下一个之后执行,可以对之后的执行结果进行进一步处理
-(id)afterDoNextFilter:(id)data error:(NSError **)error;

//生成错误信息
-(id)errorWithData:(id) data error:(NSError **) error;
//包装数据
//-(id)doWrapper:(id)data error:(NSError **)error;
//
//-(id)afterNextWrapper:(id)data error:(NSError **)error;

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////
static NSString *kHDFilterErrorDomain = @"hand.filter";
static const NSInteger kHDFilterErrorCode = 101;
static NSString *kHDFilterErrorDataKey = @"filterdata";

@interface HDDataFilter : NSObject <HDDataFilter>

//下一个过滤器
@property (nonatomic,retain) id <HDDataFilter> nextFilter;

-(id)initWithNextFilter:(id<HDDataFilter>) next;



@end


