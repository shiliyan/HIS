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


//将审批数据提交到服务器

-(void)commitApproveSuccess:(ASIHTTPRequest *)request withDataSet:(NSArray *)dataset;

-(void)commitApproveError:(ASIHTTPRequest *)request withMessage:(NSString *)errorMessage;
-(void)commitApproveServerError:(ASIHTTPRequest *)request withResponseStatus:(NSString *)status;
-(void)commitApproveNetWorkError:(ASIHTTPRequest *)request;
-(void)commitRequestQueueFinished:(ASINetworkQueue *)queue;

@end

@implementation ApproveListController

@synthesize detailController;
@synthesize formRequest;
@synthesize networkQueue;
@synthesize selectedArray;
@synthesize tableAdapter;
@synthesize dataTableView;
@synthesize normalToolbar;
@synthesize checkToolBar;
@synthesize bottomStatusLabel;
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

        NSString * theURL = [NSString stringWithFormat:@"tt://approve_detail/Detail/6"];
        NSDictionary * dataInfo = [NSDictionary dictionaryWithObject:data forKey:@"data"];
        
        [[TTNavigator navigator] openURLAction:[[[TTURLAction actionWithURLPath:theURL] applyQuery:dataInfo] applyAnimated:YES]];
        
        [dataTableView deselectRowAtIndexPath:indexPath animated:YES];
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
    [dataTableView setEditing:!dataTableView.editing animated:YES];
    if (dataTableView.editing){
        [self.navigationItem.rightBarButtonItem setTitle:@"取消"];
        [normalToolbar resignFirstResponder];
        normalToolbar.hidden = YES;
        checkToolBar.hidden = NO;
        adoptButton.enabled = NO;
        refuseButton.enabled = NO;
        
        adoptButton.title = @"通过";
        refuseButton.title = @"拒绝";
    }
    else{
        [self.navigationItem.rightBarButtonItem setTitle:@"批量"];
        [checkToolBar resignFirstResponder];
        checkToolBar.hidden = YES;
        normalToolbar.hidden = NO;
    }
}

// TODO: 编写失败和网络连接错误的回调
#pragma mark - 刷新数据
-(void)refreshTable{
    // 获取最新的待办列表
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
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter release];
    
    [bottomStatusLabel setText:[NSString stringWithFormat:@"更新成功 %@",currentDateStr]];

    //responseArray，返回数据解析后存放
    NSMutableArray *responseArray =[[NSMutableArray alloc]init];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSMutableDictionary *record in dataset) {
        Approve *responseEntity = [[Approve alloc]initWithDictionary:record];
        [responseEntity setLocalStatus:@"NORMAL"];
        [responseArray addObject:responseEntity];
        
        BOOL foundTheSame = false;
        
        for (Approve *localEntity in tableAdapter.approveArray) {
            if (localEntity.recordId == responseEntity.recordId) {
                foundTheSame = true;
                break;
            }
        }
        
        //说明在本地待办中没有找到recordId相同的项
        if (!foundTheSame) {
            for (Approve *localWaitingEntity in tableAdapter.commitArray) {
                if (localWaitingEntity.recordId == responseEntity.recordId) {
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
        NSString *sql = [NSString stringWithFormat:@"insert into %@ (%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) values ('%i','%i','%@','%@','%@','%@','%@','%@','%@','%@','%i','%@')",TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_WORKFLOW_ID,APPROVE_PROPERTY_RECORD_ID,APPROVE_PROPERTY_WORKFLOW_NAME,APPROVE_PROPERTY_WORKFLOW_DESC,APPROVE_PROPERTY_NODE_NAME,APPROVE_PROPERTY_EMPLOYEE_NAME,APPROVE_PROPERTY_CREATION_DATE,APPROVE_PROPERTY_DATE_LIMIT,APPROVE_PROPERTY_IS_LATE,APPROVE_PROPERTY_LOCAL_STATUS,APPROVE_PROPERTY_COMMENT,APPROVE_PROPERTY_SCREEN_NAME,approve.workflowId,approve.recordId,approve.workflowName,approve.workflowDesc,approve.nodeName,approve.employeeName,approve.creationDate,approve.dateLimit,approve.isLate,approve.localStatus,approve.comment,approve.screenName];
        [dbHelper.db executeUpdate:sql];
        approve.rowId = sqlite3_last_insert_rowid([dbHelper.db sqliteHandle]);
    }
    [dbHelper.db close];
    
    
    NSMutableArray *newIndexPaths = [NSMutableArray array];
    NSLog(@"new temp: %@",tempArray);
    [dataTableView beginUpdates];
    //插入待审批数据源（因为本地缺少的数据只可能是新数据，所以不用比较，直接从列表前段插入）
    [tableAdapter.approveArray insertObjects:tempArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [tempArray count])]];
    //生成新的indexPaths
    for (int i=0; i<tempArray.count; i++) {
        [newIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:SECTION_NORMAL]];
    }
    NSLog(@"%@",newIndexPaths);
    [dataTableView insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationMiddle];
    [dataTableView endUpdates];
    
    //查找本地有差异的数据
    [tempArray removeAllObjects];
    for (Approve *localEntity in tableAdapter.approveArray) {
        BOOL foundTheSame = false;
        for (Approve *responseEntity in responseArray) {
            if (localEntity.recordId == responseEntity.recordId) {
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
    [dataTableView beginUpdates];
    NSUInteger beginIndex = 0;
    for (Approve *differentEntity in tempArray) {
        NSUInteger fromIndex = [tableAdapter.approveArray indexOfObject:differentEntity];
        [dataTableView moveRowAtIndexPath:[NSIndexPath indexPathForRow:fromIndex inSection:SECTION_NORMAL] toIndexPath:[NSIndexPath indexPathForRow:beginIndex inSection:SECTION_PROBLEM_LIST]];
        beginIndex++;
    }
    [tableAdapter.approveArray removeObjectsInArray:tempArray];
    [tableAdapter.errorArray insertObjects:tempArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, tempArray.count)]];
    [dataTableView endUpdates];
    
    [dbHelper.db open];
    //将有差异的数据存表
    for (Approve *entity in tempArray) {
        [dbHelper.db executeUpdate:[NSString stringWithFormat:@"update %@ set %@ = '%@' where %@ = '%i'",TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_LOCAL_STATUS,entity.localStatus,@"rowid",entity.rowId]];
    }
    [dbHelper.db close];

    [responseArray release];
}

-(void)queryFailed{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络无连接或服务器无响应" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    
    bottomStatusLabel.text = @"更新失败";
}

#pragma mark - 审批动作
//审批动作
-(IBAction)doAction:(id)sender{
    
    NSArray *selectedIndexPaths = [dataTableView indexPathsForSelectedRows];
    
    [self.selectedArray removeAllObjects];
    for (NSIndexPath *path in selectedIndexPaths) {
        Approve *approve = [tableAdapter.approveArray objectAtIndex:[path row]];
        [selectedArray addObject:approve];
    }
    
    [self showOpinionView:[sender tag]];
}


#pragma mark -实现模态视图的dismiss delegate
-(void)ApproveOpinionViewDismissed:(int)resultCode messageDictionary:(NSDictionary *)dictionary{
    
    //点“提交”按钮
    if(resultCode == RESULT_OK){
        NSLog(@"%@",selectedArray);
        adoptButton.title = @"通过";
        refuseButton.title = @"拒绝";
        adoptButton.enabled = NO;
        refuseButton.enabled = NO;
        
        [self dismissModalViewControllerAnimated:YES];
        
        //设置数据
        NSString *action = [dictionary objectForKey:@"type"];
        NSString *comment = [dictionary objectForKey:@"comment"];
        NSString *submitUrl = [HDURLCenter requestURLWithKey:@"APPROVE_TABLE_BATCH_COMMIT"];
        NSString *localStatus = @"WAITING";
        
        //修改approveList中的数据
        for (int i = 0; i < selectedArray.count; i++) {
            Approve *selectedEntity = selectedEntity = [selectedArray objectAtIndex:i];
            selectedEntity.action = action;
            selectedEntity.comment = comment;
            selectedEntity.submitUrl = submitUrl;
            selectedEntity.localStatus = localStatus;
            for (int j = 0; j < tableAdapter.approveArray.count; j++) {
                Approve *approveEntity = [tableAdapter.approveArray objectAtIndex:j];
                if(selectedEntity.rowId == approveEntity.rowId){
                    approveEntity.action = action;
                    approveEntity.comment = comment;
                    approveEntity.submitUrl = submitUrl;
                    approveEntity.localStatus = localStatus;
                    break;
                }
            }
        }
        
        [dbHelper.db open];
        for (Approve *entity in selectedArray) {
            NSString *sql = [NSString stringWithFormat:@"update %@ set %@ = '%@',%@ = '%@',%@ = '%@',%@ = '%@' where %@ = '%i'",TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_COMMENT,comment,APPROVE_PROPERTY_APPROVE_ACTION,action,APPROVE_PROPERTY_LOCAL_STATUS,localStatus,APPROVE_PROPERTY_SUBMIT_URL,submitUrl,@"rowid",entity.rowId];
            [dbHelper.db executeUpdate:sql];
        }
        [dbHelper.db close];
        
        //移动UI，从待审批到等待提交
        NSUInteger toIndex = 0;
        NSMutableArray *changedIndexPaths = [NSMutableArray arrayWithCapacity:selectedArray.count];
        [dataTableView beginUpdates];
        for (Approve *selectedEntity in selectedArray) {
            NSUInteger fromIndex = [tableAdapter.approveArray indexOfObject:selectedEntity];
            NSIndexPath *fromIndexPath = [NSIndexPath indexPathForRow:fromIndex inSection:SECTION_NORMAL];
            NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:toIndex inSection:SECTION_WAITING_LIST];
            [dataTableView deselectRowAtIndexPath:fromIndexPath animated:YES];
            [dataTableView moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
            [changedIndexPaths addObject:toIndexPath];
            toIndex++;
        }
        [tableAdapter.approveArray removeObjectsInArray:selectedArray];
        [tableAdapter.commitArray insertObjects:selectedArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, selectedArray.count)]];
        [dataTableView endUpdates];
        
        [dataTableView reloadRowsAtIndexPaths:changedIndexPaths withRowAnimation:UITableViewRowAnimationFade];
        
        //准备提交数据
        for (Approve *approve in selectedArray) {
            NSMutableDictionary *data = [NSMutableDictionary dictionary];
            [data setObject:[NSNumber numberWithInt:approve.recordId] forKey:APPROVE_PROPERTY_RECORD_ID];
            [data setObject:approve.action forKey:@"action_id"];
            [data setObject:approve.comment forKey:APPROVE_PROPERTY_COMMENT];
            
            //准备request对象
            HDFormDataRequest *request = [HDFormDataRequest hdRequestWithURL:approve.submitUrl withData:data pattern:HDrequestPatternNormal];
            request.tag = approve.rowId;
            [request setDelegate:self];
            [request setSuccessSelector:@selector(commitApproveSuccess:withDataSet:)];
            [request setErrorSelector:@selector(commitApproveError:withMessage:)];
            [request setFailedSelector:@selector(commitApproveNetWorkError:)];
            [request setServerErrorSelector:@selector(commitApproveServerError:withResponseStatus:)];
            
            [self.networkQueue addOperation:request];
        }
    }
    //点“取消”按钮
    else if (resultCode == RESULT_CANCEL){
        [self dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark - 提交数据到服务器
-(IBAction)commitApproveToServer:(id)sender{

    [bottomStatusLabel setText:@"正在处理"];
    if([tableAdapter.commitArray count] != 0){
        
        for (Approve *approve in tableAdapter.commitArray) {
            //准备提交数据
            NSMutableDictionary *data = [NSMutableDictionary dictionary];
            [data setObject:[NSNumber numberWithInt:approve.recordId] forKey:APPROVE_PROPERTY_RECORD_ID];
            [data setObject:approve.comment forKey:APPROVE_PROPERTY_COMMENT];
            [data setObject:approve.action forKey:@"action_id"];
            
            //准备request对象
            HDFormDataRequest *request = [HDFormDataRequest hdRequestWithURL:approve.submitUrl withData:data pattern:HDrequestPatternNormal];
            request.tag = approve.rowId;
            [request setDelegate:self];
            [request setSuccessSelector:@selector(commitApproveSuccess:withDataSet:)];
            [request setErrorSelector:@selector(commitApproveError:withMessage:)];
            [request setFailedSelector:@selector(commitApproveNetWorkError:)];
            [request setServerErrorSelector:@selector(commitApproveServerError:withResponseStatus:)];
            
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
    [dataTableView beginUpdates];
    for (int i=0; i<tableAdapter.commitArray.count; i++) {
        Approve *currentEntity = [tableAdapter.commitArray objectAtIndex:i];
        if (currentEntity.rowId = request.tag) {
            targetIndex = i;
            [tableAdapter.commitArray removeObject:currentEntity];
            break;
        }
    }
    [dataTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:targetIndex inSection:SECTION_WAITING_LIST]] withRowAnimation:UITableViewRowAnimationFade];
    [dataTableView endUpdates];
    
}

-(void)commitApproveError:(ASIHTTPRequest *)request withMessage:(NSString *)errorMessage{
    NSLog(@"%@, tag:%i",NSStringFromSelector(_cmd),request.tag);
    
    //修改数据
    [dbHelper.db open];
    NSString *sql = [NSString stringWithFormat:@"update %@ set %@ = 'ERROR',%@ = '%@' where %@ = '%i' ;",TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_LOCAL_STATUS,APPROVE_PROPERTY_SERVER_MESSAGE,errorMessage,@"rowid",request.tag];
    [dbHelper.db executeUpdate:sql];
    [dbHelper.db close];
    
    //移动UI元素
    NSUInteger targetIndex = 0;
    NSArray *changedIndexPaths = nil;
   
    [dataTableView beginUpdates];
    for (int i=0; i<tableAdapter.commitArray.count; i++) {
        Approve *currentEntity = [tableAdapter.commitArray objectAtIndex:i];
        if (currentEntity.rowId = request.tag) {
            targetIndex = i;
            currentEntity.localStatus = @"ERROR";
            currentEntity.serverMessage = errorMessage;
            NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:0 inSection:SECTION_PROBLEM_LIST];
            [dataTableView moveRowAtIndexPath:[NSIndexPath indexPathForRow:targetIndex inSection:SECTION_WAITING_LIST] toIndexPath:toIndexPath];
            changedIndexPaths = [NSArray arrayWithObject:toIndexPath];
            [tableAdapter.errorArray insertObject:currentEntity atIndex:0];
            [tableAdapter.commitArray removeObject:currentEntity];
            break;
        }
    }
    [dataTableView endUpdates];
    
    [dataTableView reloadRowsAtIndexPaths:changedIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    
}

#pragma mark - 提交审批时网络故障
-(void)commitApproveNetWorkError:(ASIHTTPRequest *)request{   
    NSLog(@"%@",NSStringFromSelector(_cmd));

}

-(void)commitApproveServerError:(ASIHTTPRequest *)request withResponseStatus:(NSString *)status{

}

-(void)commitRequestQueueFinished:(ASINetworkQueue *)queue{
    NSLog(@"queue finished");
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
    NSLog(@"%@",recognizer);
    if(recognizer.state == UIGestureRecognizerStateEnded){
        CGPoint swipeLocation = [recognizer locationInView:self.dataTableView];
        NSIndexPath *swipedIndexPath = [self.dataTableView indexPathForRowAtPoint:swipeLocation];
        NSUInteger swipedSection = swipedIndexPath.section;
        
        Approve *entity = nil;
        if(swipedSection == SECTION_PROBLEM_LIST){
            entity = [tableAdapter.errorArray objectAtIndex:[swipedIndexPath row]];
            
        }else{
            //其他区域不可删除
            return;
        }
        [dbHelper.db open];
        BOOL success = [dbHelper.db executeUpdate:[NSString stringWithFormat:@"delete from %@ where %@ = '%i'",TABLE_NAME_APPROVE_LIST,@"rowid",entity.rowId]];
        [dbHelper.db close];
        
        if(success){
            [tableAdapter.errorArray removeObjectAtIndex:[swipedIndexPath row]];
            [dataTableView beginUpdates];
            [dataTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:swipedIndexPath] withRowAnimation:UITableViewRowAnimationRight];
            [dataTableView endUpdates];
        }
        
    }
}

#pragma mark - 初始加载视图时，从数据库中读出所有数据
-(void)initTableViewData{
    
    //从数据库读取数据(应该放到一个业务逻辑类中)
    [dbHelper.db open];
    NSString *sql = [NSString stringWithFormat:@"select rowid, %@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@ from %@ order by %@ desc",APPROVE_PROPERTY_WORKFLOW_ID,APPROVE_PROPERTY_RECORD_ID,APPROVE_PROPERTY_WORKFLOW_NAME,APPROVE_PROPERTY_WORKFLOW_DESC,APPROVE_PROPERTY_NODE_NAME,APPROVE_PROPERTY_EMPLOYEE_NAME,APPROVE_PROPERTY_CREATION_DATE,APPROVE_PROPERTY_DATE_LIMIT,APPROVE_PROPERTY_IS_LATE,APPROVE_PROPERTY_LOCAL_STATUS,APPROVE_PROPERTY_COMMENT,APPROVE_PROPERTY_APPROVE_ACTION,APPROVE_PROPERTY_SCREEN_NAME,APPROVE_PROPERTY_SERVER_MESSAGE, APPROVE_PROPERTY_SUBMIT_URL,TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_CREATION_DATE];
    FMResultSet *resultSet = [dbHelper.db executeQuery:sql];
    // 初始列表数据
    NSMutableArray *datas = [[NSMutableArray alloc]init];
    
    while ([resultSet next]) {
        Approve *a= [[Approve alloc]initWithRowId:[resultSet intForColumn:@"rowid"] workflowId:[resultSet intForColumn:APPROVE_PROPERTY_WORKFLOW_ID] recordId:[resultSet intForColumn:APPROVE_PROPERTY_RECORD_ID] workflowName:[resultSet stringForColumn:APPROVE_PROPERTY_WORKFLOW_NAME] workflowDesc:[resultSet stringForColumn:APPROVE_PROPERTY_WORKFLOW_DESC] nodeName:[resultSet stringForColumn:APPROVE_PROPERTY_NODE_NAME] employeeName:[resultSet stringForColumn:APPROVE_PROPERTY_EMPLOYEE_NAME] creationDate:[resultSet stringForColumn:APPROVE_PROPERTY_CREATION_DATE] dateLimit:[resultSet stringForColumn:APPROVE_PROPERTY_DATE_LIMIT] isLate:[resultSet intForColumn:APPROVE_PROPERTY_IS_LATE] screenName:[resultSet stringForColumn:APPROVE_PROPERTY_SCREEN_NAME] localStatus:[resultSet stringForColumn:APPROVE_PROPERTY_LOCAL_STATUS] comment:[resultSet stringForColumn:APPROVE_PROPERTY_COMMENT] actionType:[resultSet stringForColumn:APPROVE_PROPERTY_APPROVE_ACTION] serverMessage:[resultSet stringForColumn:APPROVE_PROPERTY_SERVER_MESSAGE] submitUrl:[resultSet stringForColumn:APPROVE_PROPERTY_SUBMIT_URL]];
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
    [dataTableView reloadData];
    [datas release];
}

-(void)addRequestIntoQueueFromCenter{
    ASIHTTPRequest *request = [[HDHTTPRequestCenter shareHTTPRequestCenter] requestWithKey:DETAIL_REQUEST_KEY requestType:HDRequestTypeFormData];
    
    [dataTableView beginUpdates];
    NSUInteger fromIndex = 0;
    for (Approve *entity in tableAdapter.approveArray) {
        if (entity.rowId == request.tag) {//
            fromIndex = [tableAdapter.approveArray indexOfObject:entity];
            [tableAdapter.commitArray insertObject:entity atIndex:0];
            [tableAdapter.approveArray removeObject:entity];
            break;
        }
    }
    [dataTableView moveRowAtIndexPath:[NSIndexPath indexPathForRow:fromIndex inSection:SECTION_NORMAL] toIndexPath:[NSIndexPath indexPathForRow:0 inSection:SECTION_WAITING_LIST]];
    [dataTableView endUpdates];
    
    [self.networkQueue addOperation:request];
    
}

#pragma mark - life circle
-(void)viewDidLoad{
    [super viewDidLoad];
    
    loadCount = 1;
    self.title = @"待办事项";
    
    self.selectedArray = [NSMutableArray array]; 
    
    //初始化数据库连接
    dbHelper = [[ApproveDatabaseHelper alloc]init];
    
    tableAdapter = [[ApproveTableAdapter alloc]init];
    [dataTableView setDelegate:self];
    [dataTableView setDataSource:tableAdapter];
    
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
    [self commitApproveToServer:nil];
    
    //初始化导航条右侧按钮
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:@"批量" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleTabelViewEdit:)]autorelease];

    UISwipeGestureRecognizer *rightRecognizer = [[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didSwip:)]autorelease];
    rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [dataTableView addGestureRecognizer:rightRecognizer];
    
    //初始化明细页面的审批请求
    HDRequestConfig * requestConfig = [[HDRequestConfig alloc]init];
    //设定请求相关回调函数
    [requestConfig setDelegate:self];
    [requestConfig setSuccessSelector:@selector(commitApproveSuccess:withDataSet:)];
    [requestConfig setServerErrorSelector:@selector(commitApproveServerError:withResponseStatus:)];
    [requestConfig setErrorSelector:@selector(commitApproveError:withMessage:)];
    [requestConfig setFailedSelector:@selector(commitApproveNetWorkError:)];  
    //获取请求配置列表
    HDRequestConfigMap * map = [[HDHTTPRequestCenter shareHTTPRequestCenter] requestConfigMap];
    //添加一个名为 detial_ready_post 的request配置
    [map addConfig:requestConfig forKey:DETAIL_REQUEST_KEY];
    //释放
    [requestConfig release];
    
    //注册到通知中心，表明对 detailApproved 消息的关注,响应方法为：,目的是将此request放在请求队列中
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addRequestIntoQueueFromCenter) name:@"detailApproved" object:nil];
    
}

-(void)viewDidUnload{
    tableAdapter = nil;
    formRequest = nil;
    networkQueue = nil;
    detailController = nil;
    normalToolbar = nil;
    checkToolBar = nil;
    dataTableView = nil;
    adoptButton = nil;
    refuseButton = nil;
    opinionView = nil;
    dbHelper = nil;
    formRequest = nil;
    [super viewDidUnload];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    if(loadCount != 1){
//        //读取本地数据
//        [self initTableViewData];
//    }
//    loadCount+=1;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

-(void)dealloc{
    [tableAdapter release];
    [formRequest release];
    [selectedArray release];
    [networkQueue cancelAllOperations];
    [networkQueue release];
    [detailController release];
    [normalToolbar release];
    [checkToolBar release];
    [dataTableView release];
    [adoptButton release];
    [refuseButton release];
    [opinionView release];
    [dbHelper release];
    [super dealloc];
}

@end
