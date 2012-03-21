//
//  ApproveOpinionViewDelegate.h
//  Approve
//
//  Created by Zhang Yi on 3/9/12.
//  Copyright (c) 2012 __HAND__. All rights reserved.
//  用于审批弹出窗的关闭delegate

#import <Foundation/Foundation.h>

@protocol ApproveOpinionViewDelegate <NSObject>

@required
-(void)ApproveOpinionViewDismissed:(int)resultCode messageObject:(NSObject *)obj;

@end
