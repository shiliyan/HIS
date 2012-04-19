//
//  Approve.h
//  Approve
//
//  Created by mas apple on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *APPROVE_PROPERTY_WORKFLOW_ID=@"workflow_id";
static NSString *APPROVE_PROPERTY_RECORD_ID=@"record_id";

//是否超时
static NSString *APPROVE_PROPERTY_IS_LATE=@"is_late";

//页面地址
static NSString *APPROVE_PROPERTY_SCREEN_NAME = @"screen_name";

//工作流名称
static NSString *APPROVE_PROPERTY_WORKFLOW_NAME=@"workflow_name";

//工作流描述
static NSString *APPROVE_PROPERTY_WORKFLOW_DESC=@"workflow_desc";

//当前节点
static NSString *APPROVE_PROPERTY_NODE_NAME=@"node_name";

//申请人
static NSString *APPROVE_PROPERTY_EMPLOYEE_NAME=@"employee_name";

//提交时间
static NSString *APPROVE_PROPERTY_CREATION_DATE=@"creation_date";

//处理时限
static NSString *APPROVE_PROPERTY_DATE_LIMIT=@"date_limit";

//本地状态
static NSString *APPROVE_PROPERTY_LOCAL_STATUS=@"local_status";

//审批意见
static NSString *APPROVE_PROPERTY_COMMENT=@"comment";

//审批动作类型
static NSString *APPROVE_PROPERTY_APPROVE_ACTION=@"action";

//服务器返回信息
static NSString *APPROVE_PROPERTY_SERVER_MESSAGE=@"server_message";

//提交的地址
static NSString *APPROVE_PROPERTY_SUBMIT_URL=@"submit_url";

@interface Approve : NSObject{
    NSNumber *rowID;//本地数据主键
    NSNumber *workflowID;
    NSNumber *recordID;
    NSString *workflowName;//工作流名称
    NSString *workflowDesc;//
    NSString *nodeName;//当前节点
    NSString *employeeName;//申请人
    NSString *creationDate;//提交时间
    NSString *dateLimit;//处理时限
    NSNumber *isLate;//催办还是代办
    NSString *screenName;//页面地址
    NSString *localStatus;//本地状态，分三类：NORMAL:正常，从服务器取得的未处理数据；WAITING:用户已处理，但未提交到服务器；Done:已提交数据，并且服务器返回ok；ERROR:错误，服务器返回的错误状态
    NSString *comment;//审批意见
    NSString *action ;//审批动作
    NSString *serverMessage;
    NSString *submitUrl;
}

@property(retain ,nonatomic) NSNumber *rowID;
@property(retain ,nonatomic) NSNumber *workflowID;
@property(retain ,nonatomic) NSNumber *recordID;
@property(copy, nonatomic) NSString *workflowName;
@property(copy, nonatomic) NSString *workflowDesc;
@property(copy, nonatomic) NSString *nodeName;
@property(copy, nonatomic) NSString *employeeName;
@property(copy, nonatomic) NSString *creationDate;
@property(copy, nonatomic) NSString *dateLimit;
@property(retain ,nonatomic) NSNumber *isLate;
@property(copy, nonatomic) NSString *screenName;
@property(copy, nonatomic) NSString *localStatus;
@property(copy, nonatomic) NSString *comment;
@property(copy, nonatomic) NSString *action;
@property(copy, nonatomic) NSString *serverMessage;
@property(copy, nonatomic) NSString *submitUrl;

-(Approve *)initWithRowId:(NSNumber *)rowid workflowId:(NSNumber *)wid recordId:(NSNumber *)rId workflowName:(NSString *)wName workflowDesc:(NSString *)wDesc nodeName:(NSString *)node employeeName:(NSString *)employee creationDate:(NSString *)creation dateLimit:(NSString *)limit  isLate:(NSNumber *)late screenName:(NSString *)screen localStatus:(NSString *)status comment:(NSString *)cmt actionType:(NSString *)aType serverMessage:(NSString *)sMessage submitUrl:(NSString *)url;

-(Approve *)initWithDictionary:(NSDictionary *)dic;
@end
