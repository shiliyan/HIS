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

-(void)deleteTableViewRows:(NSArray *)indexPathsArray;

-(void)showOpinionView:(int)approveType;

-(void)querySuccess:(NSMutableArray *)dataset;
-(void)queryFailed;


//将审批数据提交到服务器

-(void)commitApproveSuccess:(NSArray *)dataset withRequest:(ASIHTTPRequest *)request;
-(void)commitApproveError:(NSString *)errorMessage withRequest:(ASIHTTPRequest *)request;
-(void)commitApproveServerError;
-(void)commitApproveNetWorkError:(ASIHTTPRequest *)request;
-(void)commitRequestQueueFinished:(ASINetworkQueue *)queue;
@end

@implementation ApproveListController

@synthesize detailController;
@synthesize approveListArray;
@synthesize problemListArray;
@synthesize commitListArray;
@synthesize formRequest;
@synthesize networkQueue;

@synthesize dataTableView;
@synthesize normalToolbar;
@synthesize checkToolBar;
@synthesize bottomStatusLabel;
@synthesize adoptButton;
@synthesize refuseButton;

#pragma mark - 覆盖 tableView 方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == SECTION_APRROVE_LIST) {
        NSUInteger count = [approveListArray count];
        return count;
    }else if(section == SECTION_WAITING_LIST){
        return [commitListArray count];
    }else if (section == SECTION_PROBLEM_LIST){
        NSUInteger count = [problemListArray count];
        return count;
    }else{
        return 0;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 3;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == SECTION_APRROVE_LIST) {
        return @"待办";
    }else if(section == SECTION_WAITING_LIST){
        return @"等待提交";
    }else if(section == SECTION_PROBLEM_LIST){
        return @"有问题";
    }else{
        return nil;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellTableIdentifier = @"ApproveCellIdentifier";
    ApproveListCell *cell= nil;
    
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    Approve *rowData = nil;

    if (section == SECTION_APRROVE_LIST) {
        rowData = [approveListArray objectAtIndex:row];
    }else if(section == SECTION_WAITING_LIST){
        rowData = [commitListArray objectAtIndex:row];
    }else if(section == SECTION_PROBLEM_LIST){
        rowData = [problemListArray objectAtIndex:row];
    }
    
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    
    if (cell == nil){
        cell = [[ApproveListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTableIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
//    UIImageView *typeImage = (UIImageView *)[cell viewWithTag:TYPEIMG_IMAGEVIEW_TAG];
//    UILabel *workFlowNameLabel = (UILabel *)[cell viewWithTag:WORKFLOW_TEXTVIEW_TAG];
//    UILabel *applicantLabel = (UILabel *)[cell viewWithTag:APPLICANT_TEXTVIEW_TAG];
//    UILabel *commitDateLabel = (UILabel *)[cell viewWithTag:COMMITDATE_TEXTVIEW_TAG];
//    UILabel *currentStatusLabel = (UILabel *)[cell viewWithTag:CURRENTSTATUS_TEXTVIEW_TAG];
//    UILabel *deadLineLabel = (UILabel *)[cell viewWithTag:DEADLINE_TEXTVIEW_TAG];
//    
//    if(rowData.isLate == 0){
//        typeImage.image = [UIImage imageNamed:@"normal_todo.png"];
//    }else{
//        typeImage.image = [UIImage imageNamed:@"normal_todo.png"];
//    }
//    workFlowNameLabel.text = rowData.workflowName;
//    applicantLabel.text = rowData.employeeName;
//    commitDateLabel.text = rowData.creationDate;
//    currentStatusLabel.text = rowData.nodeName;
//    deadLineLabel.text = rowData.dateLimit;
    [cell setCellData:rowData];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.isEditing){
        NSArray *selectedIndexPaths = [tableView indexPathsForSelectedRows];
        adoptButton.title = [NSString stringWithFormat:@"通过 (%i)",[selectedIndexPaths count]];
        refuseButton.title = [NSString stringWithFormat:@"拒绝 (%i)",[selectedIndexPaths count]];
        
        if ([selectedIndexPaths count]>0){
            adoptButton.enabled = YES;
            refuseButton.enabled = YES;
        }
    }else{
        [ [TTNavigator navigator] openURLAction:[[[TTURLAction actionWithURLPath:@"tt://approve_detail/Detail"]applyAnimated:YES] applyQuery: [NSDictionary dictionaryWithObject: [approveListArray objectAtIndex:indexPath.row] forKey:@"detailRecord"]]];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger section = [indexPath section];
    if (section == SECTION_APRROVE_LIST) {
        return true;
    }else{
        return false;
    }
}

//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if (editingStyle == UITableViewCellEditingStyleDelete){
//        [tableView setEditing:NO animated:YES];
//        [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
//        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//        [self showOpinionView:ACTION_TYPE_ADOPT];
//    }
//    return;
//}

-(void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    if (dataTableView.editing){
        [self.navigationItem.rightBarButtonItem setTitle:@"Cancel"];
        
    }
    else{
        [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
    }
}

-(void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (dataTableView.editing){
        [self.navigationItem.rightBarButtonItem setTitle:@"Edit"]; 
    }
    else{
        [self.navigationItem.rightBarButtonItem setTitle:@"Cancel"];
    }

}

//-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return @"通过"; 
//}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([tableView isEditing]) {
        return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
//    }
//    return UITableViewCellEditingStyleDelete;
    
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
            entity = [problemListArray objectAtIndex:[swipedIndexPath row]];
            
        }else{
            //其他区域不可删除
            return;
        }
        [dbHelper.db open];
        BOOL success = [dbHelper.db executeUpdate:[NSString stringWithFormat:@"delete from %@ where %@ = '%i' and %@ = '%@'",TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_RECORD_ID,entity.recordId,APPROVE_PROPERTY_LOCAL_STATUS,@"ERROR"]];
        [dbHelper.db close];
        
        if(success){
            [problemListArray removeObjectAtIndex:[swipedIndexPath row]];
            [dataTableView beginUpdates];
            [dataTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:swipedIndexPath] withRowAnimation:UITableViewRowAnimationRight];
            [dataTableView endUpdates];
        }
        
    }
}

-(void)toggleTabelViewEdit:(id)sender{
    [dataTableView setEditing:!dataTableView.editing animated:YES];
    if (dataTableView.editing){
        [self.navigationItem.rightBarButtonItem setTitle:@"Cancel"];
        [normalToolbar resignFirstResponder];
        normalToolbar.hidden = YES;
        checkToolBar.hidden = NO;
        adoptButton.enabled = NO;
        refuseButton.enabled = NO;
        
        adoptButton.title = @"通过";
        refuseButton.title = @"拒绝";
    }
    else{
        [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
        [checkToolBar resignFirstResponder];
        checkToolBar.hidden = YES;
        normalToolbar.hidden = NO;
    }
}

// TODO: 编写失败和网络连接错误的回调
#pragma mark - 刷新数据
-(void)refreshTable{
    // 获取最新的待办列表
    
    self.formRequest  = [HDFormDataRequest hdRequestWithURL:@"http://localhost:8080/hr_new/autocrud/ios.IOS_APPROVE.ios_workflow_approve_query/query" pattern:HDrequestPatternNormal];
    
    [formRequest setDelegate:self];
    [formRequest setSuccessSelector:@selector(querySuccess:)];
    [formRequest setErrorSelector:@selector(queryFailed)];
    [formRequest setAsiFaildSelector:@selector(queryFailed)];
    [formRequest setServerErrorSelector:@selector(queryFailed)];
    [formRequest startAsynchronous];
}


#pragma mark - 从服务器端取数据成功
//从服务器端取数据成功
-(void)querySuccess:(NSMutableArray *)dataset{
    
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
        
        for (Approve *localEntity in approveListArray) {
            if (localEntity.recordId == responseEntity.recordId) {
                foundTheSame = true;
                break;
            }
        }
        
        //说明在本地待办中没有找到recordId相同的项
        if (!foundTheSame) {
            for (Approve *localWaitingEntity in commitListArray) {
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
    [approveListArray addObjectsFromArray:tempArray];
    
    [dbHelper.db open];
    for (Approve *approve in tempArray) {
        NSString *sql = [NSString stringWithFormat:@"insert into %@ (%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) values ('%i','%i','%@','%@','%@','%@','%@','%@','%i','%@','%@','%i','%@');",TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_WORKFLOW_ID,APPROVE_PROPERTY_RECORD_ID,APPROVE_PROPERTY_WORKFLOW_NAME,APPROVE_PROPERTY_WORKFLOW_DESC,APPROVE_PROPERTY_NODE_NAME,APPROVE_PROPERTY_EMPLOYEE_NAME,APPROVE_PROPERTY_CREATION_DATE,APPROVE_PROPERTY_DATE_LIMIT,APPROVE_PROPERTY_IS_LATE,APPROVE_PROPERTY_LOCAL_STATUS,APPROVE_PROPERTY_COMMENT,APPROVE_PROPERTY_APPROVE_ACTION_TYPE,APPROVE_PROPERTY_SCREEN_NAME,approve.workflowId,approve.recordId,approve.workflowName,approve.workflowDesc,approve.nodeName,approve.employeeName,approve.creationDate,approve.dateLimit,approve.isLate,approve.localStatus,approve.comment,approve.approveActionType,approve.screenName];
        [dbHelper.db executeUpdate:sql];
    }
    [dbHelper.db close];
    
    [tempArray removeAllObjects];
    for (Approve *localEntity in approveListArray) {
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
            [localEntity setLocalStatus:@"ERROR"];
            [tempArray addObject:localEntity];
        }
    }
    [problemListArray addObjectsFromArray:tempArray];
    [approveListArray removeObjectsInArray:tempArray];
    

    [dbHelper.db open];
    //将有差异的数据存表
    for (Approve *entity in tempArray) {
        [dbHelper.db executeUpdate:[NSString stringWithFormat:@"update %@ set %@ = '%@' where %@ = '%i'",TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_LOCAL_STATUS,entity.localStatus,APPROVE_PROPERTY_RECORD_ID,entity.recordId]];
    }
    [dbHelper.db close];
    [dataTableView beginUpdates];
    
    [dataTableView reloadSections:[NSIndexSet indexSetWithIndex:SECTION_APRROVE_LIST] withRowAnimation:UITableViewRowAnimationFade];
    [dataTableView reloadSections:[NSIndexSet indexSetWithIndex:SECTION_PROBLEM_LIST] withRowAnimation:UITableViewRowAnimationFade];
    [dataTableView endUpdates];
    [responseArray release];
}

-(void)queryFailed{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"刷新数据失败" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

#pragma mark - 审批动作
//通过申请
-(IBAction)adoptApplication:(id)sender{
    [self showOpinionView:ACTION_TYPE_ADOPT];
}

//拒绝申请
-(IBAction)refuseApplication:(id)sender{
    [self showOpinionView:ACTION_TYPE_REFUSE];
}

#pragma mark -实现模态视图的dismiss delegate
-(void)ApproveOpinionViewDismissed:(int)resultCode messageDictionary:(NSDictionary *)dictionary{
    
    
    //点“提交”按钮
    if(resultCode == RESULT_OK){
        NSUInteger type = [[dictionary objectForKey:@"type"]intValue];
        NSString *comment = [dictionary objectForKey:@"comment"];
        
        NSArray *selectedIndexPaths = [dataTableView indexPathsForSelectedRows];
        
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSIndexPath *path in selectedIndexPaths) {
            Approve *approve = [approveListArray objectAtIndex:[path row]];
            approve.comment = comment;
            approve.approveActionType = type;
            approve.localStatus = @"WAITING";
            [tempArray addObject:approve];
        }
        
        [dbHelper.db open];
        for (Approve *entity in tempArray) {
            NSString *sql = [NSString stringWithFormat:@"update %@ set %@ = '%@',%@ = '%i',%@ = '%@' where %@ = '%i' and %@ = '%@'",TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_COMMENT,entity.comment,APPROVE_PROPERTY_APPROVE_ACTION_TYPE,entity.approveActionType,APPROVE_PROPERTY_LOCAL_STATUS,entity.localStatus,APPROVE_PROPERTY_RECORD_ID,entity.recordId,APPROVE_PROPERTY_LOCAL_STATUS,@"NORMAL"];
            [dbHelper.db executeUpdate:sql];
        }
        [dbHelper.db close];
        
        [commitListArray addObjectsFromArray:tempArray];
        [approveListArray removeObjectsInArray:tempArray];
        
        //移动选中的列到“提交中”中
        
        adoptButton.title = @"通过";
        refuseButton.title = @"拒绝";
        adoptButton.enabled = NO;
        refuseButton.enabled = NO;
        
        [self dismissModalViewControllerAnimated:YES];
        [self commitApproveToServer:nil];
        
    }
    //点“取消”按钮
    else if (resultCode == RESULT_CANCEL){
        [self dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark - 提交数据到服务器
-(IBAction)commitApproveToServer:(id)sender{

    [bottomStatusLabel setText:@"正在处理"];
    if([commitListArray count] != 0){
        
        [self.networkQueue cancelAllOperations];
        self.networkQueue = [ASINetworkQueue queue];
        [[self networkQueue] setDelegate:self];
        [[self networkQueue] setQueueDidFinishSelector:@selector(commitRequestQueueFinished:)];
        [self.networkQueue setMaxConcurrentOperationCount:1 ];
        [self.networkQueue setShouldCancelAllRequestsOnFailure:YES];
        
        for (Approve *approve in commitListArray) {
            //准备提交数据
            NSMutableDictionary *data = [NSMutableDictionary dictionary];
            [data setObject:[NSNumber numberWithInt:approve.recordId] forKey:APPROVE_PROPERTY_RECORD_ID];
            [data setObject:[NSNumber numberWithInt:approve.approveActionType] forKey:@"action_type"];
            [data setObject:approve.comment forKey:APPROVE_PROPERTY_COMMENT];
            
            //准备request对象
            HDFormDataRequest *request = [HDFormDataRequest hdRequestWithURL:@"http://localhost:8080/webtest/Approve" withData:data pattern:HDrequestPatternNormal];
            request.tag = approve.recordId;
            [request setDelegate:self];
            [request setSuccessSelector:@selector(commitApproveSuccess:withRequest:)];
            [request setErrorSelector:@selector(commitApproveError:withRequest:)];
            [request setAsiFaildSelector:@selector(commitApproveNetWorkError:)];
            [request setServerErrorSelector:@selector(commitApproveServerError)];
            
            [self.networkQueue addOperation:request];
        }
        [networkQueue go];
        
    }else{
        [self refreshTable];
    }
}

#pragma mark - 提交审批，成功
-(void)commitApproveSuccess:(NSArray *)dataset withRequest:(ASIHTTPRequest *)request{
    NSLog(@"%@, request tag : %i",NSStringFromSelector(_cmd),request.tag);
    
    [dbHelper.db open];
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@ = '%i' ",TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_RECORD_ID,request.tag];
    [dbHelper.db executeUpdate:sql];
    [dbHelper.db close];
    
    
    
    for (Approve *approve in commitListArray) {
        if (approve.recordId == request.tag) {
            [commitListArray removeObject:approve];
            break;
        }
    }
    
    //重新读取待提交的界面
    [dataTableView beginUpdates];
    [dataTableView reloadSections:[NSIndexSet indexSetWithIndex:SECTION_WAITING_LIST] withRowAnimation:UITableViewRowAnimationFade];
    [dataTableView endUpdates];

    
}

-(void)commitApproveError:(NSString *)errorMessage withRequest:(ASIHTTPRequest *)request{
    
    [dbHelper.db open];
    NSString *sql = [NSString stringWithFormat:@"update %@ set %@ = 'ERROR' where %@ = '%i';",TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_LOCAL_STATUS,APPROVE_PROPERTY_RECORD_ID,request.tag];
    [dbHelper.db executeUpdate:sql];
    [dbHelper.db close];
    
    
    for (Approve *approve in commitListArray) {
        if (approve.recordId == request.tag) {
            [problemListArray addObject:approve];
            [commitListArray removeObject:approve];
            break;
        }
    }
    //重新读取界面
    [dataTableView beginUpdates];
    [dataTableView reloadSections:[NSIndexSet indexSetWithIndex:SECTION_PROBLEM_LIST] withRowAnimation:UITableViewRowAnimationFade];
    [dataTableView reloadSections:[NSIndexSet indexSetWithIndex:SECTION_WAITING_LIST] withRowAnimation:UITableViewRowAnimationFade];
    [dataTableView endUpdates];
    
}

#pragma mark - 提交审批时网络故障
-(void)commitApproveNetWorkError:(ASIHTTPRequest *)request{   
    NSLog(@"%@",NSStringFromSelector(_cmd));

}

-(void)commitApproveServerError{
//    NSLog(@"%@",NSStringFromSelector(_cmd));
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"服务器响应错误" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
//    [alert show];
//    [alert release];
}

-(void)commitRequestQueueFinished:(ASINetworkQueue *)queue{
    NSLog(@"queue finished");
    [self refreshTable];
}

//弹出审批意见
-(void)showOpinionView:(int)actionType{
    if(opinionView == nil){
        opinionView = [[ApproveOpinionView alloc]initWithNibName:@"ApproveOpinionView" bundle:nil];
        opinionView.modalTransitionStyle =UIModalTransitionStyleCoverVertical;
        [opinionView setControllerDelegate:self];
    }
    opinionView.approveType = actionType;
    [self presentModalViewController:opinionView animated:YES];
}

-(void)deleteTableViewRows:(NSArray *)indexPathsArray{
    
    NSMutableArray *toBeDeletedApproveArray = [[NSMutableArray alloc]initWithCapacity:[approveListArray count]];
    NSMutableArray *toBeDeletedProblemArray = [[NSMutableArray alloc]initWithCapacity:[problemListArray count]];
    for (NSIndexPath *p in indexPathsArray) {
        NSUInteger row = [p row];
        if([p section]==SECTION_APRROVE_LIST){
            [toBeDeletedApproveArray addObject:[approveListArray objectAtIndex:row]];
        }else if([p section]==SECTION_PROBLEM_LIST){
            [toBeDeletedProblemArray addObject:[problemListArray objectAtIndex:row]];
        }
    }
    [approveListArray removeObjectsInArray:toBeDeletedApproveArray];
    [problemListArray removeObjectsInArray:toBeDeletedProblemArray];
    
    [dataTableView deleteRowsAtIndexPaths:indexPathsArray  withRowAnimation:UITableViewRowAnimationFade];

    adoptButton.title = @"通过";
    refuseButton.title = @"拒绝";
    adoptButton.enabled = NO;
    refuseButton.enabled = NO;
    
    [toBeDeletedApproveArray release];
    [toBeDeletedProblemArray release];
}

#pragma mark - 初始加载视图时，从数据库中读出所有数据
-(void)initTableViewData{
    
    //初始化数据库连接
    dbHelper = [[ApproveDatabaseHelper alloc]init];
    
    //从数据库读取数据(应该放到一个业务逻辑类中)
    [dbHelper.db open];
    NSString *sql = [NSString stringWithFormat:@"select %@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@ from %@ ",APPROVE_PROPERTY_WORKFLOW_ID,APPROVE_PROPERTY_RECORD_ID,APPROVE_PROPERTY_WORKFLOW_NAME,APPROVE_PROPERTY_WORKFLOW_DESC,APPROVE_PROPERTY_NODE_NAME,APPROVE_PROPERTY_EMPLOYEE_NAME,APPROVE_PROPERTY_CREATION_DATE,APPROVE_PROPERTY_DATE_LIMIT,APPROVE_PROPERTY_IS_LATE,APPROVE_PROPERTY_LOCAL_STATUS,APPROVE_PROPERTY_COMMENT,APPROVE_PROPERTY_APPROVE_ACTION_TYPE,APPROVE_PROPERTY_SCREEN_NAME,TABLE_NAME_APPROVE_LIST];

    FMResultSet *resultSet = [dbHelper.db executeQuery:sql];
    
    // 初始列表数据
    NSMutableArray *datas = [[NSMutableArray alloc]init];
    
    while ([resultSet next]) {
        Approve *a= [[Approve alloc]initWithWorkflowId:[resultSet intForColumn:APPROVE_PROPERTY_WORKFLOW_ID] recordId:[resultSet intForColumn:APPROVE_PROPERTY_RECORD_ID] workflowName:[resultSet stringForColumn:APPROVE_PROPERTY_WORKFLOW_NAME] workflowDesc:[resultSet stringForColumn:APPROVE_PROPERTY_WORKFLOW_DESC] nodeName:[resultSet stringForColumn:APPROVE_PROPERTY_NODE_NAME] employeeName:[resultSet stringForColumn:APPROVE_PROPERTY_EMPLOYEE_NAME] creationDate:[resultSet stringForColumn:APPROVE_PROPERTY_CREATION_DATE] dateLimit:[resultSet stringForColumn:APPROVE_PROPERTY_DATE_LIMIT] isLate:[resultSet intForColumn:APPROVE_PROPERTY_IS_LATE] screenName:[resultSet stringForColumn:APPROVE_PROPERTY_SCREEN_NAME] localStatus:[resultSet stringForColumn:APPROVE_PROPERTY_LOCAL_STATUS] comment:[resultSet stringForColumn:APPROVE_PROPERTY_COMMENT] approveActionType:[resultSet intForColumn:APPROVE_PROPERTY_APPROVE_ACTION_TYPE]];
        [datas addObject:a];
        [a release];
    }
    
    approveListArray = [[NSMutableArray alloc]init];
    commitListArray = [[NSMutableArray alloc]init];
    problemListArray = [[NSMutableArray alloc]init];
    
    for (Approve *entity in datas) {
        if ([entity.localStatus isEqualToString:@"NORMAL"]) {
            [approveListArray addObject:entity];
        }else if([entity.localStatus isEqualToString:@"WAITING"]){
            [commitListArray addObject:entity];
        }else if([entity.localStatus isEqualToString:@"ERROR"]){
            [problemListArray addObject:entity];
        }
    }
    [resultSet close];
    [dbHelper.db close];
    [dataTableView reloadData];
    [datas release];
}

#pragma mark - life circle
-(void)viewDidLoad{
    [super viewDidLoad];
    loadCount = 1;
    self.title = @"待办事项";
    
    //读取本地数据
    [self initTableViewData];
    [self commitApproveToServer:nil];
    
    self.navigationItem.leftBarButtonItem = nil;
    
    //初始化导航条右侧按钮
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleTabelViewEdit:)]autorelease];

    
    
    
    UISwipeGestureRecognizer *rightRecognizer = [[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didSwip:)]autorelease];
    rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [dataTableView addGestureRecognizer:rightRecognizer];
    
    
    
}

-(void)viewDidUnload{
    approveListArray =nil;
    problemListArray = nil;
    commitListArray = nil;
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
    
    if(loadCount != 1){
        //读取本地数据
        [self initTableViewData];
    }
    loadCount+=1;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

-(void)dealloc{
    [approveListArray release];
    [problemListArray release];
    [commitListArray release];
    [formRequest release];
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
