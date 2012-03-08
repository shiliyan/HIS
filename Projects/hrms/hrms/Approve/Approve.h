//
//  Approve.h
//  Approve
//
//  Created by mas apple on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

static  NSString *TODO_TYPE_HURRY = @"HURRY";
static  NSString *TODO_TYPE_NORMAL = @"NORMAL";
static const int TODO_TYPE = 2;

@interface Approve : NSObject{
    NSInteger workflowId;
    NSString *workflowName;//工作流名称
    NSString *currentStatus;//当前节点
    NSString *applicant;//申请人
    NSString *commitDate;//提交时间
    NSString *deadLine;//处理时限
    NSString *type;//催办还是代办
}

@property(nonatomic) NSInteger workflowId;
@property(copy, nonatomic) NSString *workflowName;
@property(copy, nonatomic) NSString *currentStatus;
@property(copy, nonatomic) NSString *applicant;
@property(copy, nonatomic) NSString *commitDate;
@property(copy, nonatomic) NSString *deadLine;
@property(copy, nonatomic) NSString *type;


-(Approve *)initWithWorkflowId:(NSInteger)wid workflowName:(NSString *)wName currentStatus:(NSString *)currentStatus applicant:(NSString *)applicant deadLine:(NSString *)deadLine commitDate:(NSString *)commitDate todoType:(NSString *)tType;
@end
