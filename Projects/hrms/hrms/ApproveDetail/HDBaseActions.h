//
//  HDBaseActions.h
//  hrms
//
//  Created by Rocky Lee on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDBaseActions : NSObject

@property (nonatomic,assign) id delegate;
@property (nonatomic,retain) id actionsObject;
@property (nonatomic,assign) SEL didLoadSelector;
@property (nonatomic,retain) id actionLoadParameters;

+(id)actionsModule;

-(void)loadActions;

-(void)callDidLoadSelector;

-(void)cancelLoadingActions;

-(void)saveActions;

-(void)removeActions;

@end