//
//  ApproveListController.m
//  Approve
//
//  Created by mas apple on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ApproveListController.h"
#import "ApproveListCell.h"
#import "Approve.h"

@implementation ApproveListController

@synthesize approveListArray;
@synthesize detailController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.hidesBottomBarWhenPushed=YES;
        UIImage* image = [UIImage imageNamed:@"star.png"];
        self.tabBarItem = [[[UITabBarItem alloc] initWithTitle:self.title image:image tag:0] autorelease];
    }
    return self;
}

#pragma mark - 覆盖 tableView 方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [approveListArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellTableIdentifier = @"ApproveCellIdentifier";
    
    ApproveListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"ApproveListCell"
        owner:self options:nil];
        
        for (id oneObject in nibs) {
            if ([oneObject isKindOfClass:[ApproveListCell class]]) {
                cell = (ApproveListCell *)oneObject;
            }
        }
    }
    
    NSUInteger row = [indexPath row];
    Approve *rowData = [approveListArray objectAtIndex:row];
    cell.approveData = rowData;
    [cell setCellDisplay];
    
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;

    //[rowData release];
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    if (detailController == nil) {
        detailController = [[ApproveListDetailController alloc]initWithNibName:@"ApproveListDetail" bundle:nil];
        
    }
    Approve *rowdata = [approveListArray objectAtIndex:[indexPath row]];
    
    detailController.data = rowdata;
    detailController.title = rowdata.workflowName;
    
    [self.navigationController pushViewController:detailController animated:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

}

#pragma mark - 手势 
-(void)didSwip:(UISwipeGestureRecognizer *)recognizer{
    NSLog(@"%@",recognizer);
    if(recognizer.state == UIGestureRecognizerStateEnded){
        CGPoint point = [recognizer locationInView:self.tableView];
        NSIndexPath *swipPointAtIndexPath = [self.tableView indexPathForRowAtPoint:point];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:swipPointAtIndexPath];
        ((ApproveListCell *)cell).workflowTextView.text = @"asdfasdf";
        [self.tableView setEditing:!self.tableView.editing animated:YES];
        if (self.tableView.editing) [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
        else
            [self.navigationItem.rightBarButtonItem setTitle:@"Move"];

    }
}

#pragma mark - life circle
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"待办事项";
    
    Approve *a= [[Approve alloc]initWithWorkflowId:2 workflowName:@"报销单申请" currentStatus:@"上级主管审批确认" applicant:@"张轶" deadLine:nil commitDate:@"2012-03-05 17:30" todoType:TODO_TYPE_NORMAL];
    Approve *b= [[Approve alloc]initWithWorkflowId:2 workflowName:@"转正申请" currentStatus:@"部门经理确认" applicant:@"欧阳昭昌" deadLine:@"2012-03-01 17:30" commitDate:@"2012-03-05 17:30" todoType:TODO_TYPE_HURRY];
    
    NSMutableArray *datas = [[NSMutableArray alloc]initWithObjects:a,b, nil];
    [a release];
    [b release];
    
    approveListArray = datas;
    
    UISwipeGestureRecognizer *rightRecognizer = [[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didSwip:)]autorelease];
    rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:rightRecognizer];
}

-(void)viewDidUnload{
    [super viewDidUnload];
    NSLog(@"%@",NSStringFromSelector(_cmd));
    approveListArray =nil;
    detailController = nil;
}
@end
