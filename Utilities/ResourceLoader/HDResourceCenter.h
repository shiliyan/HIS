//
//  HDResourceLoader.h
//  hrms
//
//  Created by Rocky Lee on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


@interface HDResourceCenter : TTURLRequestModel

+(void)load;

+(NSString *)filePathWithFileName:(NSString *)fileName;

@end
