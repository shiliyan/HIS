//
//  HDRoleSelectModule.h
//  hrms
//
//  Created by Rocky Lee on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HDRoleSelectDelegate;

@interface HDRoleSelectModule : NSObject
{   
    id <HDRoleSelectDelegate> delegate;
}

@property (assign) SEL roleSelectSuccessSelector;
@property (assign) SEL roleSelectFailedSelector;

@property (nonatomic,retain) HDFormDataRequest * roleSelectRequest;
@property (nonatomic,assign) id <HDRoleSelectDelegate> delegate;

-(void)selectRole:(id) roleRecord;

@end

@protocol HDRoleSelectDelegate <NSObject>

@optional
//登陆成功
-(void)roleSelectSuccess:(NSArray *) dataSet;

//服务器登陆错误
-(void)roleSelectFailed:(NSString *) errorMessage;

@end
