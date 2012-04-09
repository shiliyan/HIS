//
//  HDLoginDelegate.h
//  hrms
//
//  Created by Rocky Lee on 3/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HDLoginDelegate <NSObject>

@required

//登陆成功
-(void)loginSuccess:(NSArray *) dataSet;

//服务器登陆错误
-(void)loginFailed:(NSString *) errorMessage;

@end
