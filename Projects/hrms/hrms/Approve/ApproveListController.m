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

-(void)refreshTable;

//通过申请
-(void)adoptApplication;

//拒绝申请
-(void)refuseApplication;

-(void)deleteTableViewRows:(NSArray *)indexPathsArray;

-(void)showOpinionView:(int)approveType;

-(void)querySuccess:(NSMutableArray *)dataset;
@end

@implementation ApproveListController

@synthesize detailController;
@synthesize approveListArray;
@synthesize problemListArray;

#pragma mark - 覆盖 tableView 方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == SECTION_APRROVE_LIST) {
        NSUInteger count = [approveListArray count];
        return count;
    }else if (section == SECTION_PROBLEM_LIST){
        NSUInteger count = [problemListArray count];
        return count;
    }else{
        return 0;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    NSUInteger number = 0;
//    if([approveListArray count]!=0)
//        number +=1;
//    if([problemListArray count]!=0)
//        number +=1;
//    return number;
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == SECTION_APRROVE_LIST) {
        return @"待办";
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
    
        return true;
    
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
    [self formRequest:@"http://localhost:8080/hr_new/autocrud/ios.IOS_APPROVE.ios_workflow_approve_query/query" withData:nil successSelector:@selector(querySuccess:) failedSelector:nil errorSelector:nil noNetworkSelector:nil];
    [bottomStatusLabel setText:@"正在刷新"];

}


#pragma mark - 从服务器端取数据成功
//从服务器端取数据成功
-(void)querySuccess:(NSMutableArray *)dataset{
    
    NSDate *now = [NSDate date];
    
    [bottomStatusLabel setText:[NSString stringWithFormat:@"更新成功 %@",now]];
    //responseArray，返回数据解析后存放
    NSMutableArray *responseArray =[[NSMutableArray alloc]initWithCapacity:5];
    
    for (NSMutableDictionary *record in dataset) {
        Approve *approveEntity = [[Approve alloc]initWithDictionary:record];
        [responseArray addObject:approveEntity];
        [approveEntity release];
    }
    
    if(![dbHelper.db open]){
        //打开数据库出错
        NSLog(@"Open database error  in %@",NSStringFromSelector(_cmd));
    }
    
    //插表，但这步应该放到一个业务处理对象中
    [dbHelper.db executeUpdate:[NSString stringWithFormat:@"delete from %@ where %@ = 'NORMAL'",TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_LOCAL_STATUS]];
    for (Approve *approve in responseArray) {
        
        NSString *sql = [NSString stringWithFormat:@"insert into %@ (%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) values ('%i','%i','%@','%@','%@','%@','%@','%@','%@','%@');",TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_WORKFLOW_ID,APPROVE_PROPERTY_RECORD_ID,APPROVE_PROPERTY_WORKFLOW_NAME,APPROVE_PROPERTY_WORKFLOW_DESC,APPROVE_PROPERTY_NODE_NAME,APPROVE_PROPERTY_EMPLOYEE_NAME,APPROVE_PROPERTY_CREATION_DATE,APPROVE_PROPERTY_DATE_LIMIT,APPROVE_PROPERTY_IS_LATE,APPROVE_PROPERTY_LOCAL_STATUS,approve.workflowId,approve.recordId,approve.workflowName,approve.workflowDesc,approve.nodeName,approve.employeeName,approve.creationDate,approve.dateLimit,approve.isLate,@"NORMAL"];
        [dbHelper.db executeUpdate:sql];
    }
    [dbHelper.db close];
    
    self.approveListArray = responseArray;
    [dataTableView numberOfRowsInSection:[approveListArray count]];
    [dataTableView reloadData];
    [responseArray release];
}

#pragma mark - 审批动作
//通过申请
-(void)adoptApplication{
    [self showOpinionView:ACTION_TYPE_ADOPT];
}

//拒绝申请
-(void)refuseApplication{
    [self showOpinionView:ACTION_TYPE_REFUSE];
}

#pragma mark -实现模态视图的dismiss delegate
-(void)ApproveOpinionViewDismissed:(int)resultCode messageObject:(NSObject *)obj{
    [self dismissModalViewControllerAnimated:YES];
    
    //点“提交”按钮
    if(resultCode == RESULT_OK){
        //删除显示元素
        [self performSelector:@selector(deleteTableViewRows:) withObject:[dataTableView indexPathsForSelectedRows] afterDelay:0.5];
    }
    //点“取消”按钮
    else if (resultCode == RESULT_CANCEL){
        
    }
}

//弹出审批意见
-(void)showOpinionView:(int)actionType{
    if(opinionView == nil){
        opinionView = [[ApproveOpinionView alloc]init];
        opinionView.modalTransitionStyle =UIModalTransitionStyleCoverVertical;
        [opinionView setControllerDelegate:self];
    }
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
    
    
    [dataTableView beginUpdates];
    
    if ([approveListArray count] == 0){
       
    }
    if([problemListArray count] == 0){
        
    }
    [dataTableView deleteRowsAtIndexPaths:indexPathsArray  withRowAnimation:UITableViewRowAnimationFade];
    [dataTableView endUpdates];
    
    
    adoptButton.title = @"通过";
    refuseButton.title = @"拒绝";
    adoptButton.enabled = NO;
    refuseButton.enabled = NO;
    
    [toBeDeletedApproveArray release];
    [toBeDeletedProblemArray release];
}

#pragma mark - life circle
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"待办事项";
    
    [self refreshTable];
    //初始化数据库连接
    dbHelper = [[ApproveDatabaseHelper alloc]init];
    
    //从数据库读取数据(应该放到一个业务逻辑类中)
    [dbHelper.db open];
    NSString *sql = [NSString stringWithFormat:@"select %@,%@,%@,%@,%@,%@,%@ from %@ where %@ = 'ERROR'",APPROVE_PROPERTY_WORKFLOW_ID,APPROVE_PROPERTY_WORKFLOW_NAME,APPROVE_PROPERTY_NODE_NAME,APPROVE_PROPERTY_EMPLOYEE_NAME,APPROVE_PROPERTY_CREATION_DATE,APPROVE_PROPERTY_DATE_LIMIT,APPROVE_PROPERTY_IS_LATE,TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_LOCAL_STATUS];
    FMResultSet *resultSet = [dbHelper.db executeQuery:sql];
    
    // 初始列表数据
    NSMutableArray *datas = [[NSMutableArray alloc]initWithCapacity:10];
    
    while ([resultSet next]) {
        Approve *a= [[Approve alloc]initWithWorkflowId:[resultSet intForColumn:APPROVE_PROPERTY_WORKFLOW_ID] workflowName:[resultSet stringForColumn:APPROVE_PROPERTY_WORKFLOW_NAME] currentStatus:[resultSet stringForColumn:APPROVE_PROPERTY_NODE_NAME] applicant:[resultSet stringForColumn:APPROVE_PROPERTY_EMPLOYEE_NAME] deadLine:[resultSet stringForColumn:APPROVE_PROPERTY_DATE_LIMIT] commitDate:[resultSet stringForColumn:APPROVE_PROPERTY_CREATION_DATE] todoType:[resultSet stringForColumn:APPROVE_PROPERTY_IS_LATE]];
        [datas addObject:a];
        [a release];
    }
    [dbHelper.db close];
    
    self.problemListArray = datas;
    [datas release];
    
    self.navigationItem.leftBarButtonItem = nil;
    
    //初始化导航条右侧按钮
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleTabelViewEdit:)]autorelease];
    
    dataTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStyleGrouped];
    dataTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [dataTableView setDelegate:self];
    [dataTableView setDataSource:self];
    [self.view addSubview:dataTableView];
    
    //初始化底部工具栏(正常状态)
    normalToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 416, 320, 44)];
    normalToolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    NSMutableArray *normalToolBarItems = [NSMutableArray array];
    //添加刷新按钮
    [normalToolBarItems addObject:[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshTable)]autorelease]];
    [normalToolbar setItems:normalToolBarItems animated:YES];
    [normalToolbar sizeToFit];
    [self.view addSubview:normalToolbar];
    
    //初始化底部状态文字
    bottomStatusLabel = [[UILabel alloc]initWithFrame:CGRectMake(74, 427, 172, 21)];
    bottomStatusLabel.text = @"status";
    
    bottomStatusLabel.backgroundColor = [UIColor clearColor];
    bottomStatusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    bottomStatusLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:bottomStatusLabel];
    
    
    //初始化选中后的工具栏
    checkToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 416, 320, 44)];
    checkToolBar.hidden = YES;
    checkToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    [checkToolBar sizeToFit];
    NSMutableArray *checkedToolBarItems = [NSMutableArray array];
    //添加审批通过按钮
    adoptButton = [[UIBarButtonItem alloc]initWithTitle:@"通过" style:UIBarButtonItemStyleBordered target:self action:@selector(adoptApplication)];
    adoptButton.tintColor = [UIColor redColor];
    adoptButton.width = 100;
    [checkedToolBarItems addObject:adoptButton];
    [checkedToolBarItems addObject:[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil]autorelease]];
    //添加审批拒绝按钮
    refuseButton = [[UIBarButtonItem alloc]initWithTitle:@"拒绝" style:UIBarButtonItemStyleBordered target:self action:@selector(refuseApplication)];
  
    refuseButton.width = 100;
    [checkedToolBarItems addObject:refuseButton];

    [checkToolBar setItems:checkedToolBarItems animated:YES];
    [self.view addSubview:checkToolBar];
        
    return;
    UISwipeGestureRecognizer *rightRecognizer = [[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didSwip:)]autorelease];
    rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [dataTableView addGestureRecognizer:rightRecognizer];
    
}

-(void)viewDidUnload{
    approveListArray =nil;
    problemListArray = nil;
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
