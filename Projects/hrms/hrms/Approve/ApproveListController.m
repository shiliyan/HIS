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
@end

@implementation ApproveListController

@synthesize detailController;


#pragma mark - 覆盖 tableView 方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [approveListArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    static NSString *CellTableIdentifier = @"ApproveCellIdentifier";
    
    NSUInteger row = [indexPath row];
    Approve *rowData = [approveListArray objectAtIndex:row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    
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
    applicantLabel.text = rowData.applicant;
    commitDateLabel.text = rowData.commitDate;
    currentStatusLabel.text = rowData.currentStatus;
    deadLineLabel.text = rowData.deadLine;
    
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

// TODO: 正式使用时使用真实回传数据
#pragma mark - 刷新数据
-(void)refreshTable{
    //responseArray，模拟服务器返回数据
    NSMutableArray *responseArray =[[NSMutableArray alloc]initWithCapacity:20];
    
    NSDate *temp = [NSDate date];
    for (int i=0; i<20; i++) {
        Approve *a= [[Approve alloc]initWithWorkflowId:i workflowName:[NSString stringWithFormat:@"转正申请 %i",[temp timeIntervalSince1970]] currentStatus:[NSString stringWithFormat:@"上级主管审批确认 %i",i] applicant:[NSString stringWithFormat:@"张轶 %i",i] deadLine:nil commitDate:@"2012-03-05 17:30" todoType:TODO_TYPE_NORMAL];
        [responseArray addObject:a];
        [a release];
    }
    
    if(![dbHelper.db open]){
        //打开数据库出错
        NSLog(@"Open database error  in %@",NSStringFromSelector(_cmd));
    }
    
    //插表，但这步应该放到一个业务处理对象中
    [dbHelper.db executeUpdate:@"delete from approve_list"];
    for (Approve *approve in responseArray) {
        NSString *sql = [NSString stringWithFormat:@"insert into approve_list (%@,%@,%@,%@,%@,%@,%@) values ('%i','%@','%@','%@','%@','%@','%@')",COLUMN_WORKFLOW_ID,COLUMN_WORKFLOW_NAME,COLUMN_CURRENT_STATUS,COLUMN_APPLICANT,COLUMN_COMMIT_DATE,COLUMN_DEADLINE,COLUMN_TYPE,approve.workflowId,approve.workflowName,approve.currentStatus,approve.applicant,approve.commitDate,approve.deadLine,approve.type];
        [dbHelper.db executeUpdate:sql];
    }
    [dbHelper.db close];
    
    
    [approveListArray release];
    approveListArray = [responseArray retain];
    [dataTableView numberOfRowsInSection:[approveListArray count]];
//    [dataTableView beginUpdates];
//    [dataTableView setDelegate:self];
//    [dataTableView setDataSource:self];
    [dataTableView reloadData];
//    [dataTableView endUpdates];
    
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
-(void)ApproveOpinionViewDismissed:(int)resultCode{
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
    
    NSMutableArray *toBeDeletedArray = [[NSMutableArray alloc]initWithCapacity:[approveListArray count]];
    for (NSIndexPath *p in indexPathsArray) {
        NSUInteger row = [p row];
        [toBeDeletedArray addObject:[approveListArray objectAtIndex:row]];
    }
    [approveListArray removeObjectsInArray:toBeDeletedArray];
    
    [dataTableView beginUpdates];
    [dataTableView deleteRowsAtIndexPaths:indexPathsArray  withRowAnimation:UITableViewRowAnimationFade];
    
    [dataTableView endUpdates];
    
    adoptButton.title = @"通过";
    refuseButton.title = @"拒绝";
    adoptButton.enabled = NO;
    refuseButton.enabled = NO;
    
    [toBeDeletedArray release];
}

#pragma mark - life circle
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"待办事项";
    
    //初始化数据库连接
    dbHelper = [[ApproveDatabaseHelper alloc]init];
    
    // 初始列表数据
    NSMutableArray *datas = [[NSMutableArray alloc]initWithCapacity:10];
    
    //从数据库读取数据(应该放到一个业务逻辑类中)
    [dbHelper.db open];
    NSString *sql = [NSString stringWithFormat:@"select %@,%@,%@,%@,%@,%@,%@ from %@",COLUMN_WORKFLOW_ID,COLUMN_WORKFLOW_NAME,COLUMN_CURRENT_STATUS,COLUMN_APPLICANT,COLUMN_COMMIT_DATE,COLUMN_DEADLINE,COLUMN_TYPE,TABLE_NAME_APPROVE_LIST];
    FMResultSet *resultSet = [dbHelper.db executeQuery:sql];
    
    while ([resultSet next]) {
        Approve *a= [[Approve alloc]initWithWorkflowId:[resultSet intForColumn:COLUMN_WORKFLOW_ID] workflowName:[resultSet stringForColumn:COLUMN_WORKFLOW_NAME] currentStatus:[resultSet stringForColumn:COLUMN_CURRENT_STATUS] applicant:[resultSet stringForColumn:COLUMN_APPLICANT] deadLine:[resultSet stringForColumn:COLUMN_DEADLINE] commitDate:[resultSet stringForColumn:COLUMN_COMMIT_DATE] todoType:[resultSet stringForColumn:COLUMN_TYPE]];
        [datas addObject:a];
        [a release];
    }
    [dbHelper.db close];
    
    approveListArray = datas;
    
    self.navigationItem.leftBarButtonItem = nil;
    
    //初始化导航条右侧按钮
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleTabelViewEdit:)]autorelease];
    
    dataTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStylePlain];
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
    
    [datas release];
}

-(void)viewDidUnload{
    approveListArray =nil;
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
    NSLog(@"%@",NSStringFromSelector(_cmd));
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}

-(void)dealloc{
    [approveListArray release];
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
