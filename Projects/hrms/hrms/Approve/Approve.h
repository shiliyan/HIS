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
static NSString *APPROVE_PROPERTY_NODE_ID = @"node_id";
static NSString *APPROVE_PROPERTY_INSTANCE_ID = @"instance_id";

//是否超时
static NSString *APPROVE_PROPERTY_IS_LATE=@"is_late";

//页面地址
static NSString *APPROVE_PROPERTY_SCREEN_NAME = @"doc_page_url";

//工作流名称
static NSString *APPROVE_PROPERTY_ORDER_TYPE=@"order_type";

//工作流描述
static NSString *APPROVE_PROPERTY_INSTANCE_DESC=@"instance_desc";

static NSString *APPROVE_PROPERTY_INSTANCE_PARAM = @"instance_param";

//当前节点
static NSString *APPROVE_PROPERTY_NODE_NAME=@"node_name";

//申请人
static NSString *APPROVE_PROPERTY_EMPLOYEE_NAME=@"employee_name";

//提交时间
static NSString *APPROVE_PROPERTY_CREATION_DATE=@"apply_date_view";

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

static NSString *APPROVE_PROPERTY_STATUS_NAME = @"status_name";

static NSString *APPROVE_PROPERTY_WORKFLOW_NAME  =@"workflow_name";

@interface Approve : NSObject

@property(retain ,nonatomic) NSNumber *rowID;//本地数据主键
@property(retain ,nonatomic) NSNumber *workflowID;
@property(retain ,nonatomic) NSNumber *recordID;
@property(retain ,nonatomic) NSNumber *nodeId;
@property(retain ,nonatomic) NSNumber *instanceId;
@property(copy, nonatomic) NSString *orderType;//工作流名称
@property(copy, nonatomic) NSString *instanceDesc;
@property(retain ,nonatomic) NSNumber *instanceParam;
@property(copy, nonatomic) NSString *nodeName;//当前节点
@property(copy, nonatomic) NSString *employeeName;//申请人
@property(copy, nonatomic) NSString *creationDate;//提交时间
@property(copy, nonatomic) NSString *dateLimit;//处理时限
@property(retain ,nonatomic) NSNumber *isLate;//催办还是代办
@property(copy, nonatomic) NSString *docPageUrl;//页面地址
@property(copy, nonatomic) NSString *localStatus;//本地状态，分三类：NORMAL:正常，从服务器取得的未处理数据；WAITING:用户已处理，但未提交到服务器；Done:已提交数据，并且服务器返回ok；ERROR:错误，服务器返回的错误状态
@property(copy, nonatomic) NSString *comment;//审批意见
@property(copy, nonatomic) NSString *action;//审批动作
@property(copy, nonatomic) NSString *serverMessage;
@property(copy, nonatomic) NSString *submitUrl;
@property(copy, nonatomic) NSString *statusName;
@property(copy, nonatomic) NSString *workflowName;


-(Approve *)initWithRowId:(NSNumber *)rowid 
               workflowId:(NSNumber *)wid 
                 recordId:(NSNumber *)rId
                   nodeId:(NSNumber *)nId 
               instanceId:(NSNumber *)insId 
                orderType:(NSString *)wName 
             instanceDesc:(NSString *)wDesc 
            instanceParam:(NSNumber *)insParam 
                 nodeName:(NSString *)node
             employeeName:(NSString *)employee 
             creationDate:(NSString *)creation 
                dateLimit:(NSString *)limit  
                   isLate:(NSNumber *)late
               screenName:(NSString *)screen 
              localStatus:(NSString *)status 
                  comment:(NSString *)cmt
               actionType:(NSString *)aType 
            serverMessage:(NSString *)sMessage
                submitUrl:(NSString *)url 
               statusName:(NSString *)sName
             workflowName:(NSString *)wfName;

-(Approve *)initWithDictionary:(NSDictionary *)dic;
@end
