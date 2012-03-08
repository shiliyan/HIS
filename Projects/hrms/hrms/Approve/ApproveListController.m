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

@implementation ApproveListController

@synthesize detailController;


#pragma mark - 覆盖 tableView 方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [approveListArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
    

    //[rowData release];
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

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    if (detailController == nil) {
        detailController = [[ApproveListDetailController alloc]initWithNibName:@"ApproveListDetail" bundle:nil];
        
    }
    Approve *rowdata = [approveListArray objectAtIndex:[indexPath row]];
    

    detailController.title = rowdata.workflowName;
    
    [self.navigationController pushViewController:detailController animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return true;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        NSLog(@"asdf");
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

-(void)toggleTabelViewEdit{
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

-(void)refreshTable{
    
}

//通过申请
-(void)adoptApplication{
    //删除显示元素
    [self deleteTableViewRows:[dataTableView indexPathsForSelectedRows]];
}

//拒绝申请
-(void)refuseApplication{
    
    //删除显示元素
    [self deleteTableViewRows:[dataTableView indexPathsForSelectedRows]];
}

-(void)deleteTableViewRows:(NSArray *)indexPathsArray{
    
    for (NSIndexPath *p in indexPathsArray) {
        NSUInteger row = [p row];
        [approveListArray removeObjectAtIndex:row];
    }
    [dataTableView beginUpdates];
    [dataTableView deleteRowsAtIndexPaths:indexPathsArray  withRowAnimation:UITableViewRowAnimationFade];
    [dataTableView endUpdates];
    
    adoptButton.title = @"通过";
    refuseButton.title = @"拒绝";
    adoptButton.enabled = NO;
    refuseButton.enabled = NO;
}

#pragma mark - life circle
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"待办事项";
    
    // 初始列表数据
    NSMutableArray *datas = [[NSMutableArray alloc]initWithCapacity:10];
    for (int i=0; i<10; i++) {
        Approve *a= [[Approve alloc]initWithWorkflowId:i workflowName:[NSString stringWithFormat:@"转正申请 %i",i] currentStatus:[NSString stringWithFormat:@"上级主管审批确认 %i",i] applicant:[NSString stringWithFormat:@"张轶 %i",i] deadLine:nil commitDate:@"2012-03-05 17:30" todoType:TODO_TYPE_NORMAL];
        [datas addObject:a];
        [a release];
    }
    
    approveListArray = datas;
    
    //初始化导航条右侧按钮
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleTabelViewEdit)]autorelease];
    
    dataTableView = [[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStylePlain]autorelease];
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
    [super viewDidUnload];
    NSLog(@"%@",NSStringFromSelector(_cmd));
    approveListArray =nil;
    detailController = nil;
    normalToolbar = nil;
    checkToolBar = nil;
    dataTableView = nil;
    adoptButton = nil;
    refuseButton = nil;
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}

-(void)dealloc{
    [super dealloc];
    [approveListArray release];
    [detailController release];
    [normalToolbar release];
    [checkToolBar release];
    [dataTableView release];
    [adoptButton release];
    [refuseButton release];
}

@end
