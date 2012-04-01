//
//  HDConvertUtil.h
//  hrms
//
//  Created by Rocky Lee on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HD_NVL(__POINTER) [HDConvertUtil NilToSpace:__POINTER]

#define HD_JSON_STRING(__POINTER) [HDConvertUtil JSONStringForObject:__POINTER]

#define HD_JSON_OBJECT(__POINTER) [HDConvertUtil ObjectForJSONString:__POINTER]
@interface HDConvertUtil : NSObject

//json数据的转换
+(id) ObjectForJSONString:(NSString *) jsonString;

+(id) JSONStringForObject:(id) object;

+(id) NilToSpace:(id)object;

@end
