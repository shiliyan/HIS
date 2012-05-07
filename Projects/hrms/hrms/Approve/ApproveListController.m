//
//  ApproveListController.m
//  Approve
//
//  Created by mas apple on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ApproveListController.h"
#import "Approve.h"
#import "ApproveListCell.h"

@interface ApproveListController()
//
-(void)toggleTabelViewEdit:(id)sender;

-(void)initTableViewData;

-(void)refreshTable;

-(void)showOpinionView:(int)approveType;

-(void)querySuccess:(ASIFormDataRequest *)request withDataSet:(NSMutableArray *)dataset;
-(void)queryFailed;

-(void)addRequestIntoQueueFromCenter;

-(void)updateApplicationBadgeNumber;

//将审批数据提交到服务器

-(void)commitApproveSuccess:(ASIHTTPRequest *)request withDataSet:(NSArray *)dataset;

-(void)commitApproveError:(ASIHTTPRequest *)request withDictionary:(NSDictionary *)errorDic;
-(void)commitApproveServerError:(ASIHTTPRequest *)request withDictionary:(NSDictionary *)errorDic;
-(void)commitApproveNetWorkError:(ASIHTTPRequest *)request;
-(void)commitRequestQueueFinished:(ASINetworkQueue *)queue;

@end

@implementation ApproveListController

@synthesize detailController;
@synthesize formRequest;
@synthesize networkQueue;

@synthesize tableAdapter;

@synthesize checkToolBar;

@synthesize adoptButton;
@synthesize refuseButton;

#pragma mark - 覆盖 tableView 方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    if (tableView.isEditing){
        NSArray *selectedIndexPaths = [tableView indexPathsForSelectedRows];
        adoptButton.title = [NSString stringWithFormat:@"通过 (%i)",[selectedIndexPaths count]];
        refuseButton.title = [NSString stringWithFormat:@"拒绝 (%i)",[selectedIndexPaths count]];
        
        if ([selectedIndexPaths count]>0){
            adoptButton.enabled = YES;
            refuseButton.enabled = YES;
        }
    }else{
        Approve *data =nil;
        if(section == SECTION_NORMAL){
            data = [tableAdapter.approveArray objectAtIndex:row];
        }else if (section == SECTION_WAITING_LIST){
            data = [tableAdapter.commitArray objectAtIndex:row];
        }else if(section == SECTION_PROBLEM_LIST){
            data = [tableAdapter.errorArray objectAtIndex:row];
        }

        NSString * theURL = [NSString stringWithFormat:@"tt://approve_detail/Detail"];
        NSDictionary * dataInfo = [NSDictionary dictionaryWithObject:data forKey:@"data"];
        
        [[TTNavigator navigator] openURLAction:[[[TTURLAction actionWithURLPath:theURL] applyQuery:dataInfo] applyAnimated:YES]];
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView.isEditing){
        NSArray *selectedIndexPaths = [tableView indexPathsForSelectedRows];
        
        adoptButton.title = [NSString stringWithFormat:@"通过 (%i)",[selectedIndexPaths count]];
        refuseButton.title = [NSString stringWithFormat:@"拒绝 (%i)",[selectedIndexPaths count]];
        
        if ([selectedIndexPaths count] == 0){
            adoptButton.enabled = NO;
            refuseButton.enabled = NO;
        }
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{

        return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}

-(void)toggleTabelViewEdit:(id)sender{
    
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    if (self.tableView.editing){
        [self.navigationItem.rightBarButtonItem setTitle:@"取消"];
        
        adoptButton.enabled = NO;
        refuseButton.enabled = NO;
        
        adoptButton.title = @"通过";
        refuseButton.title = @"拒绝";
        
        [UIView animateWithDuration:0.25f animations:^{
            CALayer *tooBarLayer = self.checkToolBar.layer;
//            tooBar.affineTransform = CGAffineTransformMakeTranslation(0, 300);
            tooBarLayer.position = CGPointMake(320/2, 345);
        }];
        
    }
    else{
        [self.navigationItem.rightBarButtonItem setTitle:@"批量"];
        [checkToolBar resignFirstResponder];
        
        [UIView animateWithDuration:0.25f animations:^{
            CALayer *tooBarLayer = self.checkToolBar.layer;
            tooBarLayer.position = CGPointMake(320/2, 390);
        }];
        
    }
    
    
}

// TODO: 编写失败和网络连接错误的回调
#pragma mark - 刷新数据
-(void)refreshTable{
    // 获取最新的待办列表
    //暂时注视
    self.formRequest  = [HDFormDataRequest hdRequestWithURL:[HDURLCenter requestURLWithKey:@"APPROVE_TABLE_QUERY_URL"] pattern:HDrequestPatternNormal];
    
    [formRequest setDelegate:self];
    [formRequest setSuccessSelector:@selector(querySuccess:withDataSet:)];
    [formRequest setErrorSelector:@selector(queryFailed)];
    [formRequest setFailedSelector:@selector(queryFailed)];
    [formRequest setServerErrorSelector:@selector(queryFailed)];
    [formRequest startAsynchronous];
}


#pragma mark - 从服务器端取数据成功
//从服务器端取数据成功
-(void)querySuccess:(ASIFormDataRequest *)request withDataSet:(NSMutableArray *)dataset{

    //responseArray，返回数据解析后存放
    NSMutableArray *responseArray =[[NSMutableArray alloc]init];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSMutableDictionary *record in dataset) {
        Approve *responseEntity = [[Approve alloc]initWithDictionary:record];
        [responseEntity setLocalStatus:@"NORMAL"];
        [responseArray addObject:responseEntity];
        
        BOOL foundTheSame = false;
        
        for (Approve *localEntity in tableAdapter.approveArray) {
            if ([localEntity.recordID isEqualToNumber:responseEntity.recordID] ) {
                foundTheSame = true;
                break;
            }
        }
        
        //说明在本地待办中没有找到recordId相同的项
        if (!foundTheSame) {
            for (Approve *localWaitingEntity in tableAdapter.commitArray) {
                if ([localWaitingEntity.recordID isEqualToNumber:responseEntity.recordID] ) {
                    foundTheSame = true;
                    break;
                }
            }
        }
        
        if (foundTheSame) {
            //在返回的数据中找到了和本地待办中相同的记录，说明本地数据没问题
        }else{
            //在返回的数据中没有找到和本地待办相同的记录，插入本地
            [tempArray addObject:responseEntity];
        }
        [responseEntity release];
    }
    
    //新增数据插表
    [dbHelper.db open];
    for (Approve *approve in tempArray) {
//        NSLog(@"%@",tempArray);
        NSString *sql = [NSString stringWithFormat:@"insert into %@ (%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_WORKFLOW_ID,APPROVE_PROPERTY_RECORD_ID,APPROVE_PROPERTY_ORDER_TYPE,APPROVE_PROPERTY_INSTANCE_DESC,APPROVE_PROPERTY_NODE_NAME,APPROVE_PROPERTY_EMPLOYEE_NAME,APPROVE_PROPERTY_CREATION_DATE,APPROVE_PROPERTY_DATE_LIMIT,APPROVE_PROPERTY_IS_LATE,APPROVE_PROPERTY_LOCAL_STATUS,APPROVE_PROPERTY_SCREEN_NAME,APPROVE_PROPERTY_NODE_ID,APPROVE_PROPERTY_INSTANCE_ID,APPROVE_PROPERTY_INSTANCE_PARAM,approve.workflowID,approve.recordID,approve.orderType,approve.instanceDesc,approve.nodeName,approve.employeeName,approve.creationDate,approve.dateLimit,approve.isLate,approve.localStatus,approve.screenName,approve.nodeId,approve.instanceId,approve.instanceParam];
        [dbHelper.db executeUpdate:sql];
        
        approve.rowID = [NSNumber numberWithInt:sqlite3_last_insert_rowid([dbHelper.db sqliteHandle])] ;
        
    }
    [dbHelper.db close];
    
    
    NSMutableArray *newIndexPaths = [NSMutableArray array];
//    NSLog(@"new temp: %@",tempArray);
    [self.tableView beginUpdates];
    //插入待审批数据源（因为本地缺少的数据只可能是新数据，所以不用比较，直接从列表前段插入）
    [tableAdapter.approveArray insertObjects:tempArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [tempArray count])]];
    //生成新的indexPaths
    for (int i=0; i<tempArray.count; i++) {
        [newIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:SECTION_NORMAL]];
    }
    [self.tableView insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationMiddle];
    [self.tableView endUpdates];
    
    //查找本地有差异的数据
    [tempArray removeAllObjects];
    for (Approve *localEntity in tableAdapter.approveArray) {
        BOOL foundTheSame = false;
        for (Approve *responseEntity in responseArray) {
            if ([localEntity.recordID isEqualToNumber:responseEntity.recordID] ) {
                foundTheSame = true;
                break;
            }
        }
        if (foundTheSame) {
            //找到相同的，说明没问题
        }else{
            //在本地数据中没有找到和服务器返回的相同的记录，说明发生了变化，存入“有差异”数组
            [localEntity setLocalStatus:@"DIFFERENT"];
            [localEntity setServerMessage:@"已在其他地方处理"];
            [tempArray addObject:localEntity];
        }
    }
    
    //移动UI行
    NSUInteger beginIndex = 0;
    NSMutableArray *reloadIndexes = [NSMutableArray array];
    [self.tableView beginUpdates];
    for (Approve *differentEntity in tempArray) {
        NSUInteger fromIndex = [tableAdapter.approveArray indexOfObject:differentEntity];
        NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:beginIndex inSection:SECTION_PROBLEM_LIST];
        [self.tableView moveRowAtIndexPath:[NSIndexPath indexPathForRow:fromIndex inSection:SECTION_NORMAL] toIndexPath:toIndexPath];
        [reloadIndexes addObject:toIndexPath];
        beginIndex++;
    }
    [tableAdapter.approveArray removeObjectsInArray:tempArray];
    [tableAdapter.errorArray insertObjects:tempArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, tempArray.count)]];
    [self.tableView endUpdates];
    [self.tableView reloadRowsAtIndexPaths:reloadIndexes withRowAnimation:UITableViewRowAnimationNone];
    
    [dbHelper.db open];
    //将有差异的数据存表
    for (Approve *entity in tempArray) {
        [dbHelper.db executeUpdate:[NSString stringWithFormat:@"update %@ set %@ = '%@',%@ = '%@' where %@ = '%@'",TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_LOCAL_STATUS,entity.localStatus,APPROVE_PROPERTY_SERVER_MESSAGE,entity.serverMessage,@"rowid",entity.rowID]];
    }
    [dbHelper.db close];

    [responseArray release];
    //更新提示数字
    [self updateApplicationBadgeNumber];
    //通知下拉刷新UI，结束显示
    [super performSelector:@selector(dataSourceDidFinishLoadingNewData:) withObject:[NSNumber numberWithInt:1] afterDelay:1.0];
}

-(void)queryFailed{
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络无连接或服务器无响应" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
//    [alert show];
//    [alert release];
    [super performSelector:@selector(dataSourceDidFinishLoadingNewData:) withObject:[NSNumber numberWithInt:0] afterDelay:1.0];
    
}

#pragma mark - 审批动作
//审批动作
-(IBAction)doAction:(id)sender{
    
    [self showOpinionView:[sender tag]];
}


#pragma mark -实现模态视图的dismiss delegate
-(void)ApproveOpinionViewDismissed:(int)resultCode messageDictionary:(NSDictionary *)dictionary{
    
    //点“提交”按钮
    if(resultCode == RESULT_OK){
        [self.networkQueue cancelAllOperations];
        
        adoptButton.title = @"通过";
        refuseButton.title = @"拒绝";
        adoptButton.enabled = NO;
        refuseButton.enabled = NO;
        
        [self dismissModalViewControllerAnimated:YES];
        
        //设置数据
        NSString *action = nil;
        if ([[dictionary objectForKey:@"type"] isEqualToString:@"0"]) {
            action = ACTION_TYPE_REFUSE;
        }else if ([[dictionary objectForKey:@"type"] isEqualToString:@"1"]){
            action = ACTION_TYPE_ADOPT;
        }
        NSString *comment = [dictionary objectForKey:@"comment"];
        NSString *submitUrl = [HDURLCenter requestURLWithKey:@"APPROVE_TABLE_BATCH_COMMIT"];
        NSString *localStatus = @"WAITING";
        
        //修改approveList中的数据
//        for (int i = 0; i < selectedArray.count; i++) {
//            Approve *selectedEntity = selectedEntity = [selectedArray objectAtIndex:i];
//            selectedEntity.action = action;
//            selectedEntity.comment = comment;
//            selectedEntity.submitUrl = submitUrl;
//            selectedEntity.localStatus = localStatus;
//            for (int j = 0; j < tableAdapter.approveArray.count; j++) {
//                Approve *approveEntity = [tableAdapter.approveArray objectAtIndex:j];
//                if([selectedEntity.rowID isEqualToNumber:approveEntity.rowID] ){
//                    approveEntity.action = action;
//                    approveEntity.comment = comment;
//                    approveEntity.submitUrl = submitUrl;
//                    approveEntity.localStatus = localStatus;
//                    break;
//                }
//            }
//        }
        NSArray *selectedIndePaths = [self.tableView indexPathsForSelectedRows];
        NSMutableArray *selectedArray = [NSMutableArray array];
        [dbHelper.db open];
        for (NSIndexPath *indexPath in selectedIndePaths) {
            NSUInteger row = [indexPath row];
            Approve *entity = [tableAdapter.approveArray objectAtIndex:row];
            entity.action = action;
            entity.comment = comment;
            entity.submitUrl = submitUrl;
            entity.localStatus = localStatus;
            NSString *sql = [NSString stringWithFormat:@"update %@ set %@ = '%@',%@ = '%@',%@ = '%@',%@ = '%@' where %@ = '%@'",TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_COMMENT,comment,APPROVE_PROPERTY_APPROVE_ACTION,action,APPROVE_PROPERTY_LOCAL_STATUS,localStatus,APPROVE_PROPERTY_SUBMIT_URL,submitUrl,@"rowid",entity.rowID];
            [dbHelper.db executeUpdate:sql];
            [selectedArray addObject:entity];
        }
        [dbHelper.db close];
        
        
//        //移动UI，从待审批到等待提交
//        NSUInteger toIndex = 0;
//        NSMutableArray *changedIndexPaths = [NSMutableArray arrayWithCapacity:selectedIndePaths.count];
//        [dataTableView beginUpdates];
//        for (Approve *selectedEntity in selectedArray) {
//            NSUInteger fromIndex = [tableAdapter.approveArray indexOfObject:selectedEntity];
//            NSIndexPath *fromIndexPath = [NSIndexPath indexPathForRow:fromIndex inSection:SECTION_NORMAL];
//            NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:toIndex inSection:SECTION_WAITING_LIST];
//            [dataTableView deselectRowAtIndexPath:fromIndexPath animated:YES];
//            [dataTableView moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
//            [changedIndexPaths addObject:toIndexPath];
//            toIndex++;
//        }
        
        //移动UI，从待审批到等待提交
        NSUInteger toIndex = 0;
        NSMutableArray *changedIndexPaths = [NSMutableArray arrayWithCapacity:selectedIndePaths.count];
        [self.tableView beginUpdates];
        for (NSIndexPath *fromIndexPath in selectedIndePaths) {
            
            
            NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:toIndex inSection:SECTION_WAITING_LIST];
            [self.tableView moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
            [changedIndexPaths addObject:toIndexPath];
            toIndex++;
        }
        
        for (NSIndexPath *indexPath in selectedIndePaths) {
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        
        [tableAdapter.approveArray removeObjectsInArray:selectedArray];
        [tableAdapter.commitArray insertObjects:selectedArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, selectedArray.count)]];
        [self.tableView endUpdates];
        
        [self.tableView reloadRowsAtIndexPaths:changedIndexPaths withRowAnimation:UITableViewRowAnimationFade];
        
        //准备提交数据
        for (Approve *approve in selectedArray) {
            NSMutableDictionary *data = [NSMutableDictionary dictionary];
            [data setObject:approve.recordID forKey:APPROVE_PROPERTY_RECORD_ID];
            [data setObject:approve.action forKey:@"action_id"];
            [data setObject:approve.comment forKey:APPROVE_PROPERTY_COMMENT];
            
            //准备request对象
            HDFormDataRequest *request = [HDFormDataRequest hdRequestWithURL:approve.submitUrl withData:data pattern:HDrequestPatternNormal];
            request.tag = approve.rowID.intValue;
            [request setDelegate:self];
            [request setSuccessSelector:@selector(commitApproveSuccess:withDataSet:)];
            [request setErrorSelector:@selector(commitApproveError:withDictionary:)];
            [request setFailedSelector:@selector(commitApproveNetWorkError:)];
            [request setServerErrorSelector:@selector(commitApproveServerError:withDictionary:)];
            
            [self.networkQueue addOperation:request];
        }
    }
    //点“取消”按钮
    else if (resultCode == RESULT_CANCEL){
        [self dismissModalViewControllerAnimated:YES];
    }
    
    [self.tableView reloadSectionIndexTitles];
}

#pragma mark - 提交数据到服务器
-(IBAction)commitApproveToServer:(id)sender{

    
    if([tableAdapter.commitArray count] != 0){
        
        for (Approve *approve in tableAdapter.commitArray) {
            //准备提交数据
            NSMutableDictionary *data = [NSMutableDictionary dictionary];
            [data setObject:approve.recordID forKey:APPROVE_PROPERTY_RECORD_ID];
            [data setObject:approve.comment forKey:APPROVE_PROPERTY_COMMENT];
            [data setObject:approve.action forKey:@"action_id"];
            
            //准备request对象
            HDFormDataRequest *request = [HDFormDataRequest hdRequestWithURL:approve.submitUrl withData:data pattern:HDrequestPatternNormal];
            request.tag = approve.rowID.intValue;
            [request setDelegate:self];
            [request setSuccessSelector:@selector(commitApproveSuccess:withDataSet:)];
            [request setErrorSelector:@selector(commitApproveError:withDictionary:)];
            [request setFailedSelector:@selector(commitApproveNetWorkError:)];
            [request setServerErrorSelector:@selector(commitApproveServerError:withDictionary:)];
            
            [self.networkQueue addOperation:request];
        }
    }else{
        [self refreshTable];
    }
}

#pragma mark - 提交审批，成功
-(void)commitApproveSuccess:(ASIHTTPRequest *)request withDataSet:(NSArray *)dataset{
    NSLog(@"%@, tag:%i",NSStringFromSelector(_cmd),request.tag);
    
    //修改数据
    [dbHelper.db open];
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@ = '%i' ",TABLE_NAME_APPROVE_LIST,@"rowid",request.tag];
    [dbHelper.db executeUpdate:sql];
    [dbHelper.db close];
    
    //删除UI元素
    NSUInteger targetIndex = 0;
    [self.tableView beginUpdates];
    for (int i=0; i<tableAdapter.commitArray.count; i++) {
        Approve *currentEntity = [tableAdapter.commitArray objectAtIndex:i];
        if (currentEntity.rowID.intValue == request.tag) {
            targetIndex = i;
            [tableAdapter.commitArray removeObject:currentEntity];
            break;
        }
    }
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:targetIndex inSection:SECTION_WAITING_LIST]] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    [self.tableView reloadSectionIndexTitles];
    
}

-(void)commitApproveError:(ASIHTTPRequest *)request withDictionary:(NSDictionary *)errorDic{
    NSLog(@"%@, tag:%i",NSStringFromSelector(_cmd),request.tag);
    
    //修改数据
    [dbHelper.db open];
    NSString *sql = [NSString stringWithFormat:@"update %@ set %@ = 'ERROR',%@ = '%@' where %@ = '%i' ;",TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_LOCAL_STATUS,APPROVE_PROPERTY_SERVER_MESSAGE,[errorDic objectForKey:ERROR_MESSAGE],@"rowid",request.tag];
    [dbHelper.db executeUpdate:sql];
    [dbHelper.db close];
    
    //移动UI元素
    NSUInteger targetIndex = 0;
    NSArray *changedIndexPaths = nil;
   
    [self.tableView beginUpdates];
    for (int i=0; i<tableAdapter.commitArray.count; i++) {
        Approve *currentEntity = [tableAdapter.commitArray objectAtIndex:i];
        if (currentEntity.rowID.intValue == request.tag) {
            targetIndex = i;
            currentEntity.localStatus = @"ERROR";
            currentEntity.serverMessage = [errorDic objectForKey:ERROR_MESSAGE];
            NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:0 inSection:SECTION_PROBLEM_LIST];
            [self.tableView moveRowAtIndexPath:[NSIndexPath indexPathForRow:targetIndex inSection:SECTION_WAITING_LIST] toIndexPath:toIndexPath];
            changedIndexPaths = [NSArray arrayWithObject:toIndexPath];
            [tableAdapter.errorArray insertObject:currentEntity atIndex:0];
            [tableAdapter.commitArray removeObject:currentEntity];
            break;
        }
    }
    [self.tableView endUpdates];
    
    [self.tableView reloadRowsAtIndexPaths:changedIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadSectionIndexTitles];
    
}

#pragma mark - 提交审批时网络故障
-(void)commitApproveNetWorkError:(ASIHTTPRequest *)request{   
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
}

-(void)commitApproveServerError:(ASIHTTPRequest *)request withDictionary:(NSDictionary *)errorDic{
    [self.tableView reloadSectionIndexTitles];

}

-(void)commitRequestQueueFinished:(ASINetworkQueue *)queue{
    NSLog(@"queue finished");
    [self updateApplicationBadgeNumber];
    [self refreshTable];
    
//    [self initTableViewData];
//    [dataTableView beginUpdates];
//    [dataTableView reloadSections:[NSIndexSet indexSetWithIndex:SECTION_PROBLEM_LIST] withRowAnimation:UITableViewRowAnimationFade];
//    [dataTableView reloadSections:[NSIndexSet indexSetWithIndex:SECTION_WAITING_LIST] withRowAnimation:UITableViewRowAnimationFade];
//    [dataTableView endUpdates];
//    [self refreshTable];
}

//弹出审批意见
-(void)showOpinionView:(int)actionType{
    if(opinionView == nil){
        opinionView = [[ApproveOpinionView alloc]initWithNibName:@"ApproveOpinionView" bundle:nil];
        opinionView.modalTransitionStyle =UIModalTransitionStyleCoverVertical;
        [opinionView setControllerDelegate:self];
    }
    [opinionView setApproveType:[NSString stringWithFormat:@"%i",actionType]];
    [self presentModalViewController:opinionView animated:YES];
}

#pragma mark - 手势 
-(void)didSwip:(UISwipeGestureRecognizer *)recognizer{
    if(recognizer.state == UIGestureRecognizerStateEnded){
        
        if(recognizer.numberOfTouches == 1){
            CGPoint swipeLocation = [recognizer locationInView:self.tableView];
            NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
            NSUInteger swipedSection = swipedIndexPath.section;
            
            Approve *entity = nil;
            if(swipedSection == SECTION_PROBLEM_LIST){
                entity = [tableAdapter.errorArray objectAtIndex:[swipedIndexPath row]];
                
            }else{
                //其他区域不可删除
                return;
            }
            [dbHelper.db open];
            BOOL success = [dbHelper.db executeUpdate:[NSString stringWithFormat:@"delete from %@ where %@ = '%@'",TABLE_NAME_APPROVE_LIST,@"rowid",entity.rowID]];
            [dbHelper.db close];
            
            if(success){
                [tableAdapter.errorArray removeObjectAtIndex:[swipedIndexPath row]];
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:swipedIndexPath] withRowAnimation:UITableViewRowAnimationRight];
                [self.tableView endUpdates];
                
                [self.tableView reloadSectionIndexTitles];
                
            }
        }else if (recognizer.numberOfTouches == 2) {
            //清除错误的记录
            [dbHelper.db open];
            NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@ in ('ERROR','DIFFERENT');",TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_LOCAL_STATUS];
            BOOL isSuccess = [dbHelper.db executeUpdate:sql];
            [dbHelper.db close];
            if(isSuccess){
                [self.tableView beginUpdates];
                [tableAdapter.errorArray removeAllObjects];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:SECTION_PROBLEM_LIST] withRowAnimation:UITableViewRowAnimationRight];
                [self.tableView endUpdates];
            }
        }else if (recognizer.numberOfTouches ==3) {
            //清除所有数据
            
            [dbHelper.db open];
            NSString *sql = [NSString stringWithFormat:@"delete from %@ ;",TABLE_NAME_APPROVE_LIST];
            BOOL isSuccess = [dbHelper.db executeUpdate:sql];
            [dbHelper.db close];
            if(isSuccess){
                [self.tableView beginUpdates];
                [tableAdapter.approveArray removeAllObjects];
                [tableAdapter.errorArray removeAllObjects];
                [tableAdapter.commitArray removeAllObjects];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:SECTION_NORMAL] withRowAnimation:UITableViewRowAnimationRight];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:SECTION_WAITING_LIST] withRowAnimation:UITableViewRowAnimationRight];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:SECTION_PROBLEM_LIST] withRowAnimation:UITableViewRowAnimationRight];
                [self.tableView endUpdates];
            }
        }
    }
}

#pragma mark - 初始加载视图时，从数据库中读出所有数据
-(void)initTableViewData{
    
    //从数据库读取数据(应该放到一个业务逻辑类中)
    [dbHelper.db open];

    NSString *sql = [NSString stringWithFormat:@"select rowid, %@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@ from %@ order by %@ desc",APPROVE_PROPERTY_WORKFLOW_ID,APPROVE_PROPERTY_RECORD_ID,APPROVE_PROPERTY_ORDER_TYPE,APPROVE_PROPERTY_INSTANCE_DESC,APPROVE_PROPERTY_NODE_NAME,APPROVE_PROPERTY_EMPLOYEE_NAME,APPROVE_PROPERTY_CREATION_DATE,APPROVE_PROPERTY_DATE_LIMIT,APPROVE_PROPERTY_IS_LATE,APPROVE_PROPERTY_LOCAL_STATUS,APPROVE_PROPERTY_COMMENT,APPROVE_PROPERTY_APPROVE_ACTION,APPROVE_PROPERTY_SCREEN_NAME,APPROVE_PROPERTY_SERVER_MESSAGE, APPROVE_PROPERTY_SUBMIT_URL,APPROVE_PROPERTY_NODE_ID,APPROVE_PROPERTY_INSTANCE_ID,APPROVE_PROPERTY_INSTANCE_PARAM,TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_CREATION_DATE];
    FMResultSet *resultSet = [dbHelper.db executeQuery:sql];
    // 初始列表数据
    NSMutableArray *datas = [[NSMutableArray alloc]init];
    
    while ([resultSet next]) {
//        Approve *a = [[Approve alloc]initWithDictionary:resultSet.resultDict];
        Approve *a= [[Approve alloc]initWithRowId:[resultSet objectForColumnName:@"rowid"] workflowId:[resultSet objectForColumnName:APPROVE_PROPERTY_WORKFLOW_ID] recordId:[resultSet objectForColumnName:APPROVE_PROPERTY_RECORD_ID] nodeId:[resultSet objectForColumnName:APPROVE_PROPERTY_NODE_ID] instanceId:[resultSet objectForColumnName:APPROVE_PROPERTY_INSTANCE_ID] orderType:[resultSet stringForColumn:APPROVE_PROPERTY_ORDER_TYPE] instanceDesc:[resultSet stringForColumn:APPROVE_PROPERTY_INSTANCE_DESC] instanceParam:[resultSet objectForColumnName:APPROVE_PROPERTY_INSTANCE_PARAM] nodeName:[resultSet stringForColumn:APPROVE_PROPERTY_NODE_NAME] employeeName:[resultSet stringForColumn:APPROVE_PROPERTY_EMPLOYEE_NAME] creationDate:[resultSet stringForColumn:APPROVE_PROPERTY_CREATION_DATE] dateLimit:[resultSet stringForColumn:APPROVE_PROPERTY_DATE_LIMIT] isLate:[resultSet objectForColumnName:APPROVE_PROPERTY_IS_LATE] screenName:[resultSet stringForColumn:APPROVE_PROPERTY_SCREEN_NAME] localStatus:[resultSet stringForColumn:APPROVE_PROPERTY_LOCAL_STATUS] comment:[resultSet stringForColumn:APPROVE_PROPERTY_COMMENT] actionType:[resultSet stringForColumn:APPROVE_PROPERTY_APPROVE_ACTION] serverMessage:[resultSet stringForColumn:APPROVE_PROPERTY_SERVER_MESSAGE] submitUrl:[resultSet stringForColumn:APPROVE_PROPERTY_SUBMIT_URL]];
        [datas addObject:a];
        [a release];
    }
    
    NSMutableArray *approveArray = [NSMutableArray array];
    NSMutableArray *commitArray = [NSMutableArray array];
    NSMutableArray *errorArray = [NSMutableArray array];
    
    for (Approve *entity in datas) {
        if ([entity.localStatus isEqualToString:@"NORMAL"]) {
            [approveArray addObject:entity];
        }else if([entity.localStatus isEqualToString:@"WAITING"]){
            [commitArray addObject:entity];
        }else if([entity.localStatus isEqualToString:@"ERROR"] || [entity.localStatus isEqualToString:@"DIFFERENT"]){
            [errorArray addObject:entity];
        }
    }
    [tableAdapter setApproveArray:approveArray commitArray:commitArray errorArray:errorArray];
    [resultSet close];
    [dbHelper.db close];

    [self.tableView reloadData];
    [datas release];
    
    [self updateApplicationBadgeNumber];
}

-(void)addRequestIntoQueueFromCenter{
    ASIHTTPRequest *request = [[HDHTTPRequestCenter shareHTTPRequestCenter] requestWithKey:DETAIL_REQUEST_KEY requestType:HDRequestTypeFormData];
    
    [self.tableView beginUpdates];
    NSUInteger fromIndex = 0;
    for (Approve *entity in tableAdapter.approveArray) {
        if (entity.rowID.intValue == request.tag) {//
            fromIndex = [tableAdapter.approveArray indexOfObject:entity];
            [tableAdapter.commitArray insertObject:entity atIndex:0];
            [tableAdapter.approveArray removeObject:entity];
            break;
        }
    }
    [self.tableView moveRowAtIndexPath:[NSIndexPath indexPathForRow:fromIndex inSection:SECTION_NORMAL] toIndexPath:[NSIndexPath indexPathForRow:0 inSection:SECTION_WAITING_LIST]];
    [self.tableView endUpdates];
    
    [self.networkQueue addOperation:request];
    
}

-(void)updateApplicationBadgeNumber{
    [UIApplication sharedApplication].applicationIconBadgeNumber = [tableAdapter.approveArray count];
}

#pragma mark - life circle
-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"待办事项";
    
    self.tabBarItem = [[UITabBarItem alloc]initWithTitle:self.title image:[UIImage imageNamed:@"mailclosed.png"] tag:(50+1)];
    
    //初始化数据库连接
    dbHelper = [[ApproveDatabaseHelper alloc]init];
    
    tableAdapter = [[ApproveTableAdapter alloc]init];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:tableAdapter];
    
    //初始化提交队列
    [self.networkQueue cancelAllOperations];
    self.networkQueue = [ASINetworkQueue queue];
    [[self networkQueue] setDelegate:self];
    [[self networkQueue] setQueueDidFinishSelector:@selector(commitRequestQueueFinished:)];
    [self.networkQueue setMaxConcurrentOperationCount:1 ];
    [self.networkQueue setShouldCancelAllRequestsOnFailure:YES];
    [self.networkQueue setShowAccurateProgress:true];
    [self.networkQueue go];
    
    //读取本地数据
    [self initTableViewData];
    
    [self performSelector:@selector(commitApproveToServer:) withObject:nil afterDelay:1];
    
    
    //初始化导航条右侧按钮
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:@"批量" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleTabelViewEdit:)]autorelease];

    
    //==========手势
    UISwipeGestureRecognizer *removeOneRecordRecognizer = [[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didSwip:)]autorelease];
    removeOneRecordRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    removeOneRecordRecognizer.numberOfTouchesRequired = 1;
    [self.tableView addGestureRecognizer:removeOneRecordRecognizer];
    
    UISwipeGestureRecognizer *removeErrorRecordRecognizer = [[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didSwip:)]autorelease];
    removeErrorRecordRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    removeErrorRecordRecognizer.numberOfTouchesRequired = 2;
    [self.tableView addGestureRecognizer:removeErrorRecordRecognizer];
    
    UISwipeGestureRecognizer *removeAllRecordRecognizer = [[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didSwip:)]autorelease];
    removeAllRecordRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    removeAllRecordRecognizer.numberOfTouchesRequired = 3;
    [self.tableView addGestureRecognizer:removeAllRecordRecognizer];
    
    //初始化明细页面的审批请求
    HDRequestConfig * requestConfig = [[HDRequestConfig alloc]init];
    //设定请求相关回调函数
    [requestConfig setDelegate:self];
    [requestConfig setSuccessSelector:@selector(commitApproveSuccess:withDataSet:)];
    [requestConfig setServerErrorSelector:@selector(commitApproveServerError:withDictionary:)];
    [requestConfig setErrorSelector:@selector(commitApproveError:withDictionary:)];
    [requestConfig setFailedSelector:@selector(commitApproveNetWorkError:)];  
    //获取请求配置列表
    HDRequestConfigMap * map = [[HDHTTPRequestCenter shareHTTPRequestCenter] requestConfigMap];
    //添加一个名为 detial_ready_post 的request配置
    [map addConfig:requestConfig forKey:DETAIL_REQUEST_KEY];
    //释放
    [requestConfig release];
    
    //注册到通知中心，表明对 detailApproved 消息的关注,响应方法为：,目的是将此request放在请求队列中
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addRequestIntoQueueFromCenter) name:@"detailApproved" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commitApproveToServer:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

-(void)viewDidUnload{
    tableAdapter = nil;
    formRequest = nil;
    networkQueue = nil;
    detailController = nil;
    
    checkToolBar = nil;
    adoptButton = nil;
    refuseButton = nil;
    opinionView = nil;
    dbHelper = nil;
    formRequest = nil;
    [super viewDidUnload];
}

-(void)dealloc{
    [tableAdapter release];
    [formRequest release];
    [networkQueue cancelAllOperations];
    [networkQueue release];
    [detailController release];
    [checkToolBar release];
    [adoptButton release];
    [refuseButton release];
    [opinionView release];
    [dbHelper release];
    [super dealloc];
}

- (void)reloadTableViewDataSource
{
    // Should be calling your tableview's model to reload.
//    [super performSelector:@selector(dataSourceDidFinishLoadingNewData:) withObject:[NSNumber numberWithInt:1] afterDelay:3.0];
    [self commitApproveToServer:nil];
}

- (void)dataSourceDidFinishLoadingNewData:(NSNumber *)loadedData
{
    // Should check if data reload was successful.
    if ([loadedData boolValue]) {
        [refreshHeaderView setCurrentDate];
        [super dataSourceDidFinishLoadingNewData:nil];
        [self.tableView reloadData];
    } else {
        [super dataSourceDidFinishLoadingNewData:nil];
        // Present an informative UIAlertView
        [self dataSourceDidFailPresentingError];
    }
}

- (void)dataSourceDidFailPresentingError
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"网络异常"
                                                        message:@"网络无连接或服务器无响应。\n请稍后再试"
                                                       delegate:self 
                                              cancelButtonTitle:@"好" 
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

@end
