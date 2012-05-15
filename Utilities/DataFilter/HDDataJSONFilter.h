//
//  HDJSONParser.h
//  Three20Lab
//
//  Created by Rocky Lee on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDataFilter.h"

/*
 *把传入数据从NSData转为JSON对象(dictionary/array)
 */

@interface HDDataToJSONFilter : HDDataFilter

@end

/*
 *把传入数据从JSON对象(dictionary/array)转为NSData
 */
@interface HDJSONToDataFilter : HDDataFilter

@end
