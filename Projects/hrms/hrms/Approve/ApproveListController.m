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

-(void)moveRows:(NSArray *)selectedIndexPaths;
//将审批数据提交到服务器

-(void)commitApproveSuccess:(NSArray *)dataset;
-(void)commitApproveError:(NSArray *)dataset;
-(void)commitApproveNetWorkError:(ASIHTTPRequest *)request;
@end

@implementation ApproveListController

@synthesize detailController;
@synthesize approveListArray;
@synthesize problemListArray;
@synthesize commitListArray;

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
    UITableViewCell *cell= nil;
    
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
    
    UIImageView *typeImage = (UIImageView *)[cell viewWithTag:TYPEIMG_IMAGEVIEW_TAG];
    UILabel *workFlowNameLabel = (UILabel *)[cell viewWithTag:WORKFLOW_TEXTVIEW_TAG];
    UILabel *applicantLabel = (UILabel *)[cell viewWithTag:APPLICANT_TEXTVIEW_TAG];
    UILabel *commitDateLabel = (UILabel *)[cell viewWithTag:COMMITDATE_TEXTVIEW_TAG];
    UILabel *currentStatusLabel = (UILabel *)[cell viewWithTag:CURRENTSTATUS_TEXTVIEW_TAG];
    UILabel *deadLineLabel = (UILabel *)[cell viewWithTag:DEADLINE_TEXTVIEW_TAG];
    
    typeImage.image = [UIImage imageNamed:@"hurry_todo.png"];
    workFlowNameLabel.text = rowData.workflowName;
    applicantLabel.text = rowData.employeeName;
    commitDateLabel.text = rowData.creationDate;
    currentStatusLabel.text = rowData.nodeName;
    deadLineLabel.text = rowData.dateLimit;
    
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

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        
    }
    return;
}

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

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"通过"; 
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEditing]) {
        return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
    }
    return UITableViewCellEditingStyleDelete;
    
}

#pragma mark - 手势 
-(void)didSwip:(UISwipeGestureRecognizer *)recognizer{
    NSLog(@"%@",recognizer);
    if(recognizer.state == UIGestureRecognizerStateEnded){

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
    
    //2 获取最新的待办列表
    [self formRequest:@"http://localhost:8080/hr_new/autocrud/ios.IOS_APPROVE.ios_workflow_approve_query/query" withData:nil successSelector:@selector(querySuccess:) failedSelector:nil errorSelector:nil noNetworkSelector:nil];
    [bottomStatusLabel setText:@"正在刷新"];
    
}


#pragma mark - 从服务器端取数据成功
//从服务器端取数据成功
-(void)querySuccess:(NSMutableArray *)dataset{
        NSDate *now = [NSDate date];
    [bottomStatusLabel setText:[NSString stringWithFormat:@"更新成功 %@",now]];

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
    [tempArray removeAllObjects];
    [tempArray addObjectsFromArray:approveListArray];
    [tempArray addObjectsFromArray:problemListArray];
    //插表，但这步应该放到一个业务处理对象中
    [dbHelper.db executeUpdate:[NSString stringWithFormat:@"delete from %@ where %@ in('ERROR','NORMAL'); ",TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_LOCAL_STATUS]];
    for (Approve *approve in tempArray) {
        NSString *sql = [NSString stringWithFormat:@"insert into %@ (%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) values ('%i','%i','%@','%@','%@','%@','%@','%@','%@','%@','%@','%i','%@');",TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_WORKFLOW_ID,APPROVE_PROPERTY_RECORD_ID,APPROVE_PROPERTY_WORKFLOW_NAME,APPROVE_PROPERTY_WORKFLOW_DESC,APPROVE_PROPERTY_NODE_NAME,APPROVE_PROPERTY_EMPLOYEE_NAME,APPROVE_PROPERTY_CREATION_DATE,APPROVE_PROPERTY_DATE_LIMIT,APPROVE_PROPERTY_IS_LATE,APPROVE_PROPERTY_LOCAL_STATUS,APPROVE_PROPERTY_COMMENT,APPROVE_PROPERTY_APPROVE_ACTION_TYPE,APPROVE_PROPERTY_SCREEN_NAME,approve.workflowId,approve.recordId,approve.workflowName,approve.workflowDesc,approve.nodeName,approve.employeeName,approve.creationDate,approve.dateLimit,approve.isLate,approve.localStatus,approve.comment,approve.approveActionType,approve.screenName];
        NSLog(@"%@, %@",NSStringFromSelector(_cmd),sql);
        [dbHelper.db executeUpdate:sql];
    }
    
    [dbHelper.db close];
    
    [dataTableView reloadData];
    [responseArray release];
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
    [self dismissModalViewControllerAnimated:YES];
    
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
        [commitListArray addObjectsFromArray:tempArray];
        [approveListArray removeObjectsInArray:tempArray];
        
        //移动选中的列到“提交中”中
        [self moveRows:selectedIndexPaths];
        
        [self commitApproveToServer:nil];
        
    }
    //点“取消”按钮
    else if (resultCode == RESULT_CANCEL){
        
    }
}

-(void)moveRows:(NSArray *)selectedIndexPaths{
    [dataTableView beginUpdates];
    NSUInteger rowCount= [dataTableView numberOfRowsInSection:SECTION_WAITING_LIST];
    NSMutableArray *newIndexPaths = [NSMutableArray array];
    for (NSIndexPath *path in selectedIndexPaths) {
        NSIndexPath *fromPath = path;
        NSIndexPath *toPath = [NSIndexPath indexPathForRow:rowCount inSection:SECTION_WAITING_LIST];
        [dataTableView deselectRowAtIndexPath:path animated:NO];
        [dataTableView moveRowAtIndexPath:fromPath toIndexPath:toPath];
        [newIndexPaths addObject:toPath];
        [toPath release];
        rowCount += 1;
    }
    [dataTableView endUpdates];
    
    
    [dataTableView reloadRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationMiddle];
    
    adoptButton.title = @"通过";
    refuseButton.title = @"拒绝";
    adoptButton.enabled = NO;
    refuseButton.enabled = NO;
}

#pragma mark - 提交数据到服务器
-(IBAction)commitApproveToServer:(id)sender{
    
    if([commitListArray count] != 0){
        NSMutableArray *dictionArray = [NSMutableArray arrayWithCapacity:[commitListArray count]];
        for (Approve *approve in commitListArray) {
            NSMutableDictionary *data = [NSMutableDictionary dictionary];
            [data setObject:[NSNumber numberWithInt:approve.recordId] forKey:APPROVE_PROPERTY_RECORD_ID];
            [data setObject:[NSNumber numberWithInt:approve.approveActionType] forKey:@"action_type"];
            [data setObject:approve.comment forKey:APPROVE_PROPERTY_COMMENT];
            [dictionArray addObject:data];
        }
        [self formRequest:@"http://localhost:8080/webtest/Approve" withData:dictionArray successSelector:@selector(commitApproveSuccess:) failedSelector:nil errorSelector:@selector(commitApproveError:) noNetworkSelector:@selector(commitApproveNetWorkError:)];
    }else{
        [self refreshTable];
    }
    
    
}

#pragma mark - 提交审批，成功
-(void)commitApproveSuccess:(NSArray *)dataset{
    //清空待提交数组
    [commitListArray removeAllObjects];
    
    [dbHelper.db open];
    [dbHelper.db executeUpdate:[NSString stringWithFormat:@"delete from %@ where %@ in('WAITING','NORMAL'); ",TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_LOCAL_STATUS]];
    for (Approve *approve in approveListArray) {
        NSString *sql = [NSString stringWithFormat:@"insert into %@ (%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) values ('%i','%i','%@','%@','%@','%@','%@','%@','%@','%@','%@','%i','%@');",TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_WORKFLOW_ID,APPROVE_PROPERTY_RECORD_ID,APPROVE_PROPERTY_WORKFLOW_NAME,APPROVE_PROPERTY_WORKFLOW_DESC,APPROVE_PROPERTY_NODE_NAME,APPROVE_PROPERTY_EMPLOYEE_NAME,APPROVE_PROPERTY_CREATION_DATE,APPROVE_PROPERTY_DATE_LIMIT,APPROVE_PROPERTY_IS_LATE,APPROVE_PROPERTY_LOCAL_STATUS,APPROVE_PROPERTY_COMMENT,APPROVE_PROPERTY_APPROVE_ACTION_TYPE,APPROVE_PROPERTY_SCREEN_NAME,approve.workflowId,approve.recordId,approve.workflowName,approve.workflowDesc,approve.nodeName,approve.employeeName,approve.creationDate,approve.dateLimit,approve.isLate,approve.localStatus,approve.comment,approve.approveActionType,approve.screenName];
        NSLog(@"%@, %@",NSStringFromSelector(_cmd),sql);
        [dbHelper.db executeUpdate:sql];
    }
    [dbHelper.db close];
    
    //重新读取待提交的界面
    [dataTableView reloadSections:[NSIndexSet indexSetWithIndex:SECTION_WAITING_LIST] withRowAnimation:UITableViewRowAnimationFade];
    
    [self refreshTable];
    
}

-(void)commitApproveError:(NSArray *)dataset{

    //清空数据表中存在的待提交的记录
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where %@ in ('%@','%@') ",TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_LOCAL_STATUS,@"WAITING",@"NORMAL"];
    [dbHelper.db open];
    [dbHelper.db executeUpdate:deleteSql];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    [tempArray addObjectsFromArray:approveListArray];
    [tempArray addObjectsFromArray:commitListArray];
    //把待提交array中的数据存表
    for (Approve *approve in tempArray) {
        NSString *updateSql = [NSString stringWithFormat:@"insert into %@(%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) values ('%i','%i','%@','%@','%@','%@','%@','%@','%@','%@','%@','%i','%@')",TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_WORKFLOW_ID,APPROVE_PROPERTY_RECORD_ID,APPROVE_PROPERTY_WORKFLOW_NAME,APPROVE_PROPERTY_WORKFLOW_DESC,APPROVE_PROPERTY_NODE_NAME,APPROVE_PROPERTY_EMPLOYEE_NAME,APPROVE_PROPERTY_CREATION_DATE,APPROVE_PROPERTY_DATE_LIMIT,APPROVE_PROPERTY_IS_LATE,APPROVE_PROPERTY_LOCAL_STATUS,APPROVE_PROPERTY_COMMENT,APPROVE_PROPERTY_APPROVE_ACTION_TYPE,APPROVE_PROPERTY_SCREEN_NAME,approve.workflowId,approve.recordId,approve.workflowName,approve.workflowDesc,approve.nodeName,approve.employeeName,approve.creationDate,approve.dateLimit,approve.isLate,approve.localStatus,approve.comment,approve.approveActionType,approve.screenName];
        NSLog(@"%@, %@",NSStringFromSelector(_cmd),updateSql);
        [dbHelper.db executeUpdate:updateSql];
    }
    [dbHelper.db close];

}

#pragma mark - 提交审批时网络故障
-(void)commitApproveNetWorkError:(ASIHTTPRequest *)request{   
    
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
    NSMutableArray *datas = [[NSMutableArray alloc]initWithCapacity:10];
    
    while ([resultSet next]) {
        Approve *a= [[Approve alloc]initWithWorkflowId:[resultSet intForColumn:APPROVE_PROPERTY_WORKFLOW_ID] recordId:[resultSet intForColumn:APPROVE_PROPERTY_RECORD_ID] workflowName:[resultSet stringForColumn:APPROVE_PROPERTY_WORKFLOW_NAME] workflowDesc:[resultSet stringForColumn:APPROVE_PROPERTY_WORKFLOW_DESC] nodeName:[resultSet stringForColumn:APPROVE_PROPERTY_NODE_NAME] employeeName:[resultSet stringForColumn:APPROVE_PROPERTY_EMPLOYEE_NAME] creationDate:[resultSet stringForColumn:APPROVE_PROPERTY_CREATION_DATE] dateLimit:[resultSet stringForColumn:APPROVE_PROPERTY_DATE_LIMIT] isLate:[resultSet stringForColumn:APPROVE_PROPERTY_IS_LATE] screenName:[resultSet stringForColumn:APPROVE_PROPERTY_SCREEN_NAME] localStatus:[resultSet stringForColumn:APPROVE_PROPERTY_LOCAL_STATUS] comment:[resultSet stringForColumn:APPROVE_PROPERTY_COMMENT] approveActionType:[resultSet intForColumn:APPROVE_PROPERTY_APPROVE_ACTION_TYPE]];
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

    [datas release];
    [resultSet close];
    [dbHelper.db close];
   
}

#pragma mark - life circle
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"待办事项";
    
    //读取本地数据
    [self initTableViewData];
    
    self.navigationItem.leftBarButtonItem = nil;
    
    //初始化导航条右侧按钮
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleTabelViewEdit:)]autorelease];

    
    [self commitApproveToServer:nil];
        
    return;
    UISwipeGestureRecognizer *rightRecognizer = [[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didSwip:)]autorelease];
    rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [dataTableView addGestureRecognizer:rightRecognizer];
    
}

-(void)viewDidUnload{
    approveListArray =nil;
    problemListArray = nil;
    commitListArray = nil;
    detailController = nil;
    normalToolbar = nil;
    checkToolBar = nil;
    dataTableView = nil;
    adoptButton = nil;
    refuseButton = nil;
    opinionView = nil;
    dbHelper = nil;
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}

-(void)dealloc{
    [approveListArray release];
    [problemListArray release];
    [commitListArray release];
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
