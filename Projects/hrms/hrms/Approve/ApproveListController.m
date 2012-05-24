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

-(void)searchRecords:(NSString *)keyword;

//将审批数据提交到服务器

-(void)commitApproveSuccess:(ASIHTTPRequest *)request withDataSet:(NSArray *)dataset;

-(void)commitApproveError:(ASIHTTPRequest *)request withDictionary:(NSDictionary *)errorDic;
-(void)commitApproveServerError:(ASIHTTPRequest *)request withDictionary:(NSDictionary *)errorDic;
-(void)commitApproveNetWorkError:(ASIHTTPRequest *)request;
-(void)commitRequestQueueFinished:(ASINetworkQueue *)queue;

-(void)_showCellAnimation;
-(void)_startCellWarningAnimation;

@end

@implementation ApproveListController

@synthesize detailController = _detailController;
@synthesize formRequest = _formRequest;
@synthesize networkQueue = _networkQueue;
@synthesize tableAdapter= _tableAdapter;
@synthesize animationCells = _animationCells;

@synthesize checkToolBar = _checkToolBar;

@synthesize adoptButton = _adoptButton;
@synthesize refuseButton = _refuseButton;
@synthesize searchCoverView = _searchCoverView;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:@"ApproveListController" bundle:nil];
    return self;
}

#pragma mark - 覆盖 tableView 方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Approve *data = [_tableAdapter.approveArray objectAtIndex:[indexPath row]];
    CGFloat cellHeight = 0;
    if (([data.localStatus isEqualToString:@"NORMAL"])||([data.localStatus isEqualToString:@"WAITING"])) {
        cellHeight = 85;
    }else {
        cellHeight = 126;
    }
    
//    if ((data.instanceDesc == nil) || (data.instanceDesc.length == 0)) {
//        cellHeight  = cellHeight - 15;
//    }
    
    return cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    if (tableView.isEditing){
        NSArray *selectedIndexPaths = [tableView indexPathsForSelectedRows];
        _adoptButton.title = [NSString stringWithFormat:@"通过 (%i)",[selectedIndexPaths count]];
        _refuseButton.title = [NSString stringWithFormat:@"拒绝 (%i)",[selectedIndexPaths count]];
        
        if ([selectedIndexPaths count]>0){
            _adoptButton.enabled = YES;
            _refuseButton.enabled = YES;
        }
    }else{
        Approve *data = [_tableAdapter.approveArray objectAtIndex:row];

        NSString * theURL = [NSString stringWithFormat:@"tt://approve_detail/Detail"];
        NSDictionary * dataInfo = [NSDictionary dictionaryWithObject:data forKey:@"data"];
        
        [[TTNavigator navigator] openURLAction:[[[TTURLAction actionWithURLPath:theURL] applyQuery:dataInfo] applyAnimated:YES]];
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView.isEditing){
        NSArray *selectedIndexPaths = [tableView indexPathsForSelectedRows];
        
        _adoptButton.title = [NSString stringWithFormat:@"通过 (%i)",[selectedIndexPaths count]];
        _refuseButton.title = [NSString stringWithFormat:@"拒绝 (%i)",[selectedIndexPaths count]];
        
        if ([selectedIndexPaths count] == 0){
            _adoptButton.enabled = NO;
            _refuseButton.enabled = NO;
        }
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{

        return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}

-(void)_showCellAnimation{
    if ((self.animationCells == nil) || (self.animationCells.count == 0)) {
        return;
    }
    UITableViewCell *cell = [self.animationCells objectAtIndex:0];
    CALayer *layer = cell.layer;
    [UIView animateWithDuration:0.2f animations:^{
        layer.affineTransform = CGAffineTransformMakeScale(1.15, 1.15);
        layer.affineTransform = CGAffineTransformIdentity; 
    }];
    [self.animationCells removeObjectAtIndex:0];
    
    if (self.animationCells.count == 0) {
        [_timer invalidate];
        [_timer release];
        _timer = nil;
    }
}

-(void)_startCellWarningAnimation{
    
    if (!_timer){
        
        for (ApproveListCell *cell in self.tableView.visibleCells) {
            if ([cell.cellData.localStatus isEqualToString:@"DIFFERENT"]||[cell.cellData.localStatus isEqualToString:@"ERROR"]) {
                [self.animationCells addObject:cell];
            }
        }
        if (self.animationCells.count == 0) {
            return;
        }
        
        SEL selector = @selector(_showCellAnimation);
        
        // Adding timer to runloop to make sure UI event won't block the timer from firing
        _timer = [[NSTimer timerWithTimeInterval:0.1f target:self selector:selector userInfo:nil repeats:YES] retain];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

-(void)toggleTabelViewEdit:(id)sender{
    
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    if (self.tableView.editing){
        [self.navigationItem.rightBarButtonItem setTitle:@"取消"];
        
        _adoptButton.enabled = NO;
        _refuseButton.enabled = NO;
        
        _adoptButton.title = @"通过";
        _refuseButton.title = @"拒绝";
        
        [UIView animateWithDuration:0.25f animations:^{
            CALayer *tooBarLayer = self.checkToolBar.layer;
//            tooBar.affineTransform = CGAffineTransformMakeTranslation(0, 300);
            tooBarLayer.position = CGPointMake(320/2, 345);
        }];
        
    }
    else{
        [self.navigationItem.rightBarButtonItem setTitle:@"批量"];
        [_checkToolBar resignFirstResponder];
        
        [UIView animateWithDuration:0.25f animations:^{
            CALayer *tooBarLayer = self.checkToolBar.layer;
            tooBarLayer.position = CGPointMake(320/2, 390);
        }];
        
    }
    
    
}

// TODO: 编写失败和网络连接错误的回调
#pragma mark - 刷新数据
-(void)refreshTable{
    if (_inSearchStatus) {
        //搜索状态不允许刷新数据
        return;
    }
    
    // 获取最新的待办列表
    self.formRequest = [[HDHTTPRequestCenter shareHTTPRequestCenter]requestWithURL:[HDURLCenter requestURLWithKey:@"APPROVE_TABLE_QUERY_URL"] requestType:HDRequestTypeFormData forKey:nil];
//    self.formRequest  = [HDFormDataRequest hdRequestWithURL:[HDURLCenter requestURLWithKey:@"APPROVE_TABLE_QUERY_URL"] pattern:HDrequestPatternNormal];
    
    [_formRequest setDelegate:self];
    [_formRequest setSuccessSelector:@selector(querySuccess:withDataSet:)];
    [_formRequest setErrorSelector:@selector(queryFailed)];
    [_formRequest setFailedSelector:@selector(queryFailed)];
    [_formRequest setServerErrorSelector:@selector(queryFailed)];
    [_formRequest startAsynchronous];
}


#pragma mark - 从服务器端取数据成功
//从服务器端取数据成功
-(void)querySuccess:(ASIFormDataRequest *)request withDataSet:(NSMutableArray *)dataset{
    
    HDGodXMLFactory *factory = [HDGodXMLFactory shareBeanFactory];
    
    //responseArray，返回数据解析后存放
    NSMutableArray *responseArray =[[NSMutableArray alloc]init];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSMutableDictionary *record in dataset) {
        Approve *responseEntity = [factory getBeanWithDic:record path:@"/service/field-mappings/field-mapping[@url_name='APPROVE_TABLE_QUERY_URL']"];
        
        [responseEntity setLocalStatus:@"NORMAL"];
        [responseArray addObject:responseEntity];
        
        BOOL foundTheSame = false;
        
        for (Approve *localEntity in _tableAdapter.approveArray) {
            if ([localEntity.recordID isEqualToNumber:responseEntity.recordID]) {
                foundTheSame = true;
                break;
            }
        }
        
        if (!foundTheSame){
            //在返回的数据中没有找到和本地待办相同的记录，插入本地
            [tempArray addObject:responseEntity];
        }
    }
    
    //新增数据插表
    [_dbHelper.db open];
    for (Approve *approve in tempArray) {
        NSString *sql = [NSString stringWithFormat:@"insert into %@ (%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) values ('%@','%@','%@',%@,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_WORKFLOW_ID,APPROVE_PROPERTY_RECORD_ID,APPROVE_PROPERTY_ORDER_TYPE,APPROVE_PROPERTY_INSTANCE_DESC,APPROVE_PROPERTY_NODE_NAME,APPROVE_PROPERTY_EMPLOYEE_NAME,APPROVE_PROPERTY_CREATION_DATE,APPROVE_PROPERTY_DATE_LIMIT,APPROVE_PROPERTY_IS_LATE,APPROVE_PROPERTY_LOCAL_STATUS,APPROVE_PROPERTY_SCREEN_NAME,APPROVE_PROPERTY_NODE_ID,APPROVE_PROPERTY_INSTANCE_ID,APPROVE_PROPERTY_INSTANCE_PARAM,approve.workflowID,approve.recordID,approve.orderType,(approve.instanceDesc == nil ? NULL : [NSString stringWithFormat:@"'%@'",approve.instanceDesc]),approve.nodeName,approve.employeeName,approve.creationDate,approve.dateLimit,approve.isLate,approve.localStatus,approve.docPageUrl,approve.nodeId,approve.instanceId,approve.instanceParam];
        [_dbHelper.db executeUpdate:sql];
        
        approve.rowID = [NSNumber numberWithInt:sqlite3_last_insert_rowid([_dbHelper.db sqliteHandle])] ;
        
    }
    [_dbHelper.db close];
    
    
    NSMutableArray *newIndexPaths = [NSMutableArray array];
    [self.tableView beginUpdates];
    //插入待审批数据源（因为本地缺少的数据只可能是新数据，所以不用比较，直接从列表前段插入）
    [_tableAdapter.approveArray insertObjects:tempArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [tempArray count])]];
    //生成新的indexPaths
    for (int i=0; i<tempArray.count; i++) {
        [newIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:SECTION_NORMAL]];
    }
    [self.tableView insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationMiddle];
    [self.tableView endUpdates];
    
    //查找本地有差异的数据
    [tempArray removeAllObjects];
    for (Approve *localEntity in _tableAdapter.approveArray) {
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
    
    // TODO: 做差异数据动画
    NSMutableArray *reloadIndexes = [NSMutableArray array];
    for (Approve *differentEntity in tempArray) {
        NSUInteger fromIndex = [_tableAdapter.approveArray indexOfObject:differentEntity];
        NSIndexPath *reloadIndex = [NSIndexPath indexPathForRow:fromIndex inSection:SECTION_NORMAL];
        [reloadIndexes addObject:reloadIndex];
    }
    [self.tableView reloadRowsAtIndexPaths:reloadIndexes withRowAnimation:UITableViewRowAnimationFade];
    
    [self _startCellWarningAnimation];
    

    [_dbHelper.db open];
    //将有差异的数据存表
    for (Approve *entity in tempArray) {
        [_dbHelper.db executeUpdate:[NSString stringWithFormat:@"update %@ set %@ = '%@',%@ = '%@' where %@ = '%@'",TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_LOCAL_STATUS,entity.localStatus,APPROVE_PROPERTY_SERVER_MESSAGE,entity.serverMessage,@"rowid",entity.rowID]];
    }
    [_dbHelper.db close];

    [responseArray release];
    //更新提示数字
    [self updateApplicationBadgeNumber];
    
    //通知下拉刷新UI，结束显示
    [self performSelector:@selector(dataSourceDidFinishLoadingNewData:) withObject:[NSNumber numberWithInt:1] afterDelay:1.0];
}

-(void)queryFailed{
    [self performSelector:@selector(dataSourceDidFinishLoadingNewData:) withObject:[NSNumber numberWithInt:0] afterDelay:1.0];
    
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
        
        _adoptButton.title = @"通过";
        _refuseButton.title = @"拒绝";
        _adoptButton.enabled = NO;
        _refuseButton.enabled = NO;
        
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
        
        
        NSArray *selectedIndePaths = [self.tableView indexPathsForSelectedRows];
        NSMutableArray *selectedArray = [NSMutableArray array];
        [_dbHelper.db open];
        for (NSIndexPath *indexPath in selectedIndePaths) {
            NSUInteger row = [indexPath row];
            Approve *entity = [_tableAdapter.approveArray objectAtIndex:row];
            entity.action = action;
            entity.comment = comment;
            entity.submitUrl = submitUrl;
            entity.localStatus = localStatus;
            NSString *sql = [NSString stringWithFormat:@"update %@ set %@ = '%@',%@ = '%@',%@ = '%@',%@ = '%@' where %@ = '%@'",TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_COMMENT,comment,APPROVE_PROPERTY_APPROVE_ACTION,action,APPROVE_PROPERTY_LOCAL_STATUS,localStatus,APPROVE_PROPERTY_SUBMIT_URL,submitUrl,@"rowid",entity.rowID];
            [_dbHelper.db executeUpdate:sql];
            [selectedArray addObject:entity];
        }
        [_dbHelper.db close];
        
        
        //移动UI，从待审批到等待提交
//        NSUInteger toIndex = 0;
        NSMutableArray *changedIndexPaths = [NSMutableArray arrayWithCapacity:selectedIndePaths.count];
        [self.tableView beginUpdates];
        //保存已经选中的记录的indexpath
        for (NSIndexPath *changedIndexPath in selectedIndePaths) {
            [changedIndexPaths addObject:changedIndexPath];
        }
        //解除选中状态
        for (NSIndexPath *indexPath in selectedIndePaths) {
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        [self.tableView endUpdates];
//        
        [self.tableView reloadRowsAtIndexPaths:changedIndexPaths withRowAnimation:UITableViewRowAnimationFade];
        
        //准备提交数据
        for (Approve *approve in selectedArray) {
            NSMutableDictionary *data = [NSMutableDictionary dictionary];
            [data setObject:approve.recordID forKey:APPROVE_PROPERTY_RECORD_ID];
            [data setObject:approve.action forKey:@"action_id"];
            [data setObject:approve.comment forKey:APPROVE_PROPERTY_COMMENT];
            
            //准备request对象
             HDFormDataRequest *request  = [[HDHTTPRequestCenter shareHTTPRequestCenter]requestWithURL:approve.submitUrl withData:data  requestType:HDRequestTypeFormData forKey:nil];
            
//            HDFormDataRequest *request = [HDFormDataRequest hdRequestWithURL:approve.submitUrl withData:data pattern:HDrequestPatternNormal];
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
-(void)commitApproveToServer{
    [self initTableViewData];
    BOOL needRefreshDataFromServer = true;
    for (Approve *approve in _tableAdapter.approveArray) {
        if ([approve.localStatus isEqualToString:@"WAITING"]) {
            //准备提交数据
            NSMutableDictionary *data = [NSMutableDictionary dictionary];
            [data setObject:approve.recordID forKey:APPROVE_PROPERTY_RECORD_ID];
            [data setObject:approve.comment forKey:APPROVE_PROPERTY_COMMENT];
            [data setObject:approve.action forKey:@"action_id"];
            
            //准备request对象
            HDFormDataRequest *request  = [[HDHTTPRequestCenter shareHTTPRequestCenter]requestWithURL:approve.submitUrl withData:data  requestType:HDRequestTypeFormData forKey:nil];
            
//            HDFormDataRequest *request = [HDFormDataRequest hdRequestWithURL:approve.submitUrl withData:data pattern:HDrequestPatternNormal];
            request.tag = approve.rowID.intValue;
            [request setDelegate:self];
            [request setSuccessSelector:@selector(commitApproveSuccess:withDataSet:)];
            [request setErrorSelector:@selector(commitApproveError:withDictionary:)];
            [request setFailedSelector:@selector(commitApproveNetWorkError:)];
            [request setServerErrorSelector:@selector(commitApproveServerError:withDictionary:)];
            
            [self.networkQueue addOperation:request];
            
            needRefreshDataFromServer = false;
        }
    }
    
    if (needRefreshDataFromServer) 
        [self refreshTable];
    
}

#pragma mark - 提交审批，成功
-(void)commitApproveSuccess:(ASIHTTPRequest *)request withDataSet:(NSArray *)dataset{
    
    //修改数据
    [_dbHelper.db open];
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@ = '%i' ",TABLE_NAME_APPROVE_LIST,@"rowid",request.tag];
    [_dbHelper.db executeUpdate:sql];
    [_dbHelper.db close];
    
    //删除UI元素
    NSUInteger targetIndex = 0;
    [self.tableView beginUpdates];
    for (int i=0; i<_tableAdapter.approveArray.count; i++) {
        Approve *currentEntity = [_tableAdapter.approveArray objectAtIndex:i];
        if (currentEntity.rowID.intValue == request.tag) {
            targetIndex = i;
            [_tableAdapter.approveArray removeObject:currentEntity];
            break;
        }
    }
    
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:targetIndex inSection:SECTION_NORMAL]] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    [self.tableView reloadSectionIndexTitles];
    
}

-(void)commitApproveError:(ASIHTTPRequest *)request withDictionary:(NSDictionary *)errorDic{
    
    //修改数据
    [_dbHelper.db open];
    NSString *sql = [NSString stringWithFormat:@"update %@ set %@ = 'ERROR',%@ = '%@' where %@ = '%i' ;",TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_LOCAL_STATUS,APPROVE_PROPERTY_SERVER_MESSAGE,[errorDic objectForKey:ERROR_MESSAGE],@"rowid",request.tag];
    [_dbHelper.db executeUpdate:sql];
    [_dbHelper.db close];
    
    // 动画刷新行，更新错误状态
    NSMutableArray *reloadIndexArray = [NSMutableArray array];
    for (Approve *entity in self.tableAdapter.approveArray) {
        if (entity.rowID.intValue == request.tag) {
            entity.localStatus = @"ERROR";
            entity.serverMessage = [errorDic objectForKey:ERROR_MESSAGE];
            NSUInteger row = [self.tableAdapter.approveArray indexOfObject:entity];
            [reloadIndexArray addObject:[NSIndexPath indexPathForRow:row inSection:SECTION_NORMAL]];
        }
    }
    [self.tableView reloadRowsAtIndexPaths:reloadIndexArray withRowAnimation:UITableViewRowAnimationFade];
}

//提交审批时网络故障
-(void)commitApproveNetWorkError:(ASIHTTPRequest *)request{   
    _errorRequestCount ++;
}

-(void)commitApproveServerError:(ASIHTTPRequest *)request withDictionary:(NSDictionary *)errorDic{
    _errorRequestCount ++;
}

-(void)commitRequestQueueFinished:(ASINetworkQueue *)queue{
    if (_errorRequestCount != 0) {
        TTAlertNoTitle(@"提交数据时发生网络连接错误，或者服务器暂时响应不正确，所有您做过的动作均已保存，请稍后通过下拉列表刷新的方式重新尝试向服务器提交数据");
        _errorRequestCount = 0;
    }
    
    [self updateApplicationBadgeNumber];
    [self refreshTable];
    
}

#pragma mark - 弹出审批意见
-(void)showOpinionView:(int)actionType{
    if(_opinionView == nil){
        _opinionView = [[ApproveOpinionView alloc]initWithNibName:@"ApproveOpinionView" bundle:nil];
        _opinionView.modalTransitionStyle =UIModalTransitionStyleCoverVertical;
        [_opinionView setControllerDelegate:self];
    }
    [_opinionView setApproveType:[NSString stringWithFormat:@"%i",actionType]];
    [self presentModalViewController:_opinionView animated:YES];
}

#pragma mark - 手势 
-(void)didSwip:(UISwipeGestureRecognizer *)recognizer{
    if(recognizer.state == UIGestureRecognizerStateEnded){
        if(recognizer.numberOfTouches == 1){
            CGPoint swipeLocation = [recognizer locationInView:self.tableView];
            NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
            
            
            Approve *entity = [_tableAdapter.approveArray objectAtIndex:[swipedIndexPath row]];
            
            if ([entity.localStatus isEqualToString:@"DIFFERENT"]) {
                [_dbHelper.db open];
                BOOL success = [_dbHelper.db executeUpdate:[NSString stringWithFormat:@"delete from %@ where %@ = '%@'",TABLE_NAME_APPROVE_LIST,@"rowid",entity.rowID]];
                [_dbHelper.db close];
                
                if(success){
                    [_tableAdapter.approveArray removeObject:entity];
                    [self.tableView beginUpdates];
                    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:swipedIndexPath] withRowAnimation:UITableViewRowAnimationRight];
                    [self.tableView endUpdates];  
                }
            }
                
            
        }else if (recognizer.numberOfTouches == 2) {
            //清除错误的记录
            [_dbHelper.db open];
            NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@ in ('ERROR','DIFFERENT');",TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_LOCAL_STATUS];
            BOOL isSuccess = [_dbHelper.db executeUpdate:sql];
            [_dbHelper.db close];
            if(isSuccess){
                [self.tableView beginUpdates];
                NSMutableArray *tempEntities = [NSMutableArray array];
                NSMutableArray *tempIndexPaths = [NSMutableArray array];
                NSUInteger targetIndex = 0;
                for (Approve *entity in _tableAdapter.approveArray) {
                    if ([entity.localStatus isEqualToString:@"ERROR"]||[entity.localStatus isEqualToString:@"DIFFERENT"]) {
                        [tempEntities addObject:entity];
                        targetIndex = [_tableAdapter.approveArray indexOfObject:entity];
                        [tempIndexPaths addObject:[NSIndexPath indexPathForRow:targetIndex inSection:SECTION_NORMAL]];
                        
                    }
                }
                [_tableAdapter.approveArray removeObjectsInArray:tempEntities];
                [self.tableView deleteRowsAtIndexPaths:tempIndexPaths withRowAnimation:UITableViewRowAnimationRight];
                [self.tableView endUpdates];
            }
        }else if (recognizer.numberOfTouches ==3) {
            //清除所有数据
            
            [_dbHelper.db open];
            NSString *sql = [NSString stringWithFormat:@"delete from %@ ;",TABLE_NAME_APPROVE_LIST];
            BOOL isSuccess = [_dbHelper.db executeUpdate:sql];
            [_dbHelper.db close];
            if(isSuccess){
                [self.tableView beginUpdates];
                [_tableAdapter.approveArray removeAllObjects];
                
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:SECTION_NORMAL] withRowAnimation:UITableViewRowAnimationRight];
                
                [self.tableView endUpdates];
            }
        }
    }
}

#pragma mark - 初始加载视图时，从数据库中读出所有数据
-(void)initTableViewData{
    
    //从数据库读取数据(应该放到一个业务逻辑类中)
    [_dbHelper.db open];

    NSString *sql = [NSString stringWithFormat:@"select rowid, %@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@ from %@ order by %@ desc",APPROVE_PROPERTY_WORKFLOW_ID,APPROVE_PROPERTY_RECORD_ID,APPROVE_PROPERTY_ORDER_TYPE,APPROVE_PROPERTY_INSTANCE_DESC,APPROVE_PROPERTY_NODE_NAME,APPROVE_PROPERTY_EMPLOYEE_NAME,APPROVE_PROPERTY_CREATION_DATE,APPROVE_PROPERTY_DATE_LIMIT,APPROVE_PROPERTY_IS_LATE,APPROVE_PROPERTY_LOCAL_STATUS,APPROVE_PROPERTY_COMMENT,APPROVE_PROPERTY_APPROVE_ACTION,APPROVE_PROPERTY_SCREEN_NAME,APPROVE_PROPERTY_SERVER_MESSAGE, APPROVE_PROPERTY_SUBMIT_URL,APPROVE_PROPERTY_NODE_ID,APPROVE_PROPERTY_INSTANCE_ID,APPROVE_PROPERTY_INSTANCE_PARAM,TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_CREATION_DATE];
    FMResultSet *resultSet = [_dbHelper.db executeQuery:sql];
    // 初始列表数据
    NSMutableArray *datas = [[NSMutableArray alloc]init];
    
    while ([resultSet next]) {
//        Approve *a = [[Approve alloc]initWithDictionary:resultSet.resultDict];
        Approve *a= [[Approve alloc]initWithRowId:[resultSet objectForColumnName:@"rowid"] workflowId:[resultSet objectForColumnName:APPROVE_PROPERTY_WORKFLOW_ID] recordId:[resultSet objectForColumnName:APPROVE_PROPERTY_RECORD_ID] nodeId:[resultSet objectForColumnName:APPROVE_PROPERTY_NODE_ID] instanceId:[resultSet objectForColumnName:APPROVE_PROPERTY_INSTANCE_ID] orderType:[resultSet stringForColumn:APPROVE_PROPERTY_ORDER_TYPE] instanceDesc:[resultSet stringForColumn:APPROVE_PROPERTY_INSTANCE_DESC] instanceParam:[resultSet objectForColumnName:APPROVE_PROPERTY_INSTANCE_PARAM] nodeName:[resultSet stringForColumn:APPROVE_PROPERTY_NODE_NAME] employeeName:[resultSet stringForColumn:APPROVE_PROPERTY_EMPLOYEE_NAME] creationDate:[resultSet stringForColumn:APPROVE_PROPERTY_CREATION_DATE] dateLimit:[resultSet stringForColumn:APPROVE_PROPERTY_DATE_LIMIT] isLate:[resultSet objectForColumnName:APPROVE_PROPERTY_IS_LATE] screenName:[resultSet stringForColumn:APPROVE_PROPERTY_SCREEN_NAME] localStatus:[resultSet stringForColumn:APPROVE_PROPERTY_LOCAL_STATUS] comment:[resultSet stringForColumn:APPROVE_PROPERTY_COMMENT] actionType:[resultSet stringForColumn:APPROVE_PROPERTY_APPROVE_ACTION] serverMessage:[resultSet stringForColumn:APPROVE_PROPERTY_SERVER_MESSAGE] submitUrl:[resultSet stringForColumn:APPROVE_PROPERTY_SUBMIT_URL]];
        [datas addObject:a];
        [a release];
    }
    
    
    [_tableAdapter setApproveArray:datas];
    [resultSet close];
    [_dbHelper.db close];

    [self.tableView reloadData];
    [datas release];
    
    [self updateApplicationBadgeNumber];
}

-(void)addRequestIntoQueueFromCenter{
    ASIHTTPRequest *request = [[HDHTTPRequestCenter shareHTTPRequestCenter] requestWithKey:DETAIL_REQUEST_KEY requestType:HDRequestTypeFormData];
    
    for (Approve *entity in _tableAdapter.approveArray) {
        if (entity.rowID.intValue == request.tag) {//
            entity.localStatus = @"WAITING";
            break;
        }
    }
    [_tableView reloadRowsAtIndexPaths:[_tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];
    [self.networkQueue addOperation:request];
    
}

-(void)updateApplicationBadgeNumber{
    NSString *sql = [NSString stringWithFormat:@"select count(*) from %@ where %@ = 'NORMAL'",TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_LOCAL_STATUS];
    int number = 0;
    [_dbHelper.db open];
    FMResultSet *rs = [_dbHelper.db executeQuery:sql];
    if (rs.next) 
        number = [rs intForColumnIndex:0];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = number;
}

#pragma mark - life circle
-(void)viewDidLoad{
    [super viewDidLoad];
    _inSearchStatus = NO;
    _errorRequestCount = 0;
    self.title = @"待办事项";
    _animationCells = [[NSMutableArray alloc]init];
    
    self.tabBarItem = [[UITabBarItem alloc]initWithTitle:self.title image:[UIImage imageNamed:@"mailclosed.png"] tag:(50+1)];
    
    //初始化数据库连接
    _dbHelper = [[ApproveDatabaseHelper alloc]init];
    
    _tableAdapter = [[ApproveTableAdapter alloc]init];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:_tableAdapter];
    
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
    
    [self performSelector:@selector(commitApproveToServer) withObject:nil afterDelay:1];
    
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commitApproveToServer) name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

-(void)viewDidUnload{
    _tableAdapter = nil;
    _formRequest = nil;
    _networkQueue = nil;
    _detailController = nil;
    _animationCells = nil;
    _timer = nil;
    _checkToolBar = nil;
    _adoptButton = nil;
    _refuseButton = nil;
    _opinionView = nil;
    _dbHelper = nil;
    _formRequest = nil;
    [super viewDidUnload];
}

-(void)dealloc{
    [_tableAdapter release];
    [_formRequest release];
    [_networkQueue cancelAllOperations];
    [_networkQueue release];
    [_animationCells release];
    [_timer invalidate];
    [_timer release];
    [_detailController release];
    [_checkToolBar release];
    [_adoptButton release];
    [_refuseButton release];
    [_opinionView release];
    [_dbHelper release];
    [super dealloc];
}

#pragma mark - 实现下拉刷新相关方法
- (void)reloadTableViewDataSource
{
    if (_inSearchStatus) {
//        [super dataSourceDidFinishLoadingNewData:[NSNumber numberWithInt:-1]];
        [self dataSourceDidFinishLoadingNewData:[NSNumber numberWithInt:-1]];
        return;
    }
    
    [self commitApproveToServer];
}

- (void)dataSourceDidFinishLoadingNewData:(NSNumber *)loadedData
{
    // Should check if data reload was successful.
    if ([loadedData isEqualToNumber:[NSNumber numberWithInt:1]]) {
        //成功
        [refreshHeaderView setCurrentDate];
        [super dataSourceDidFinishLoadingNewData:nil];
        [self.tableView reloadData];
    } else if ([loadedData isEqualToNumber:[NSNumber numberWithInt:-1]]){
        //搜索状态，不能查询
        [super dataSourceDidFinishLoadingNewData:nil];
        // Present an informative UIAlertView
        [self dataSourceCantRefresh];
    } else  {
        //网络异常
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

- (void)dataSourceCantRefresh{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"当前为搜索数据状态无法获取新数据。如果需要刷新数据，请先在搜索条上点“取消”。"
                                                       delegate:self 
                                              cancelButtonTitle:@"好" 
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

#pragma mark - 实现搜索框代理方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar.text.length>0) {
        [UIView animateWithDuration:0.25 animations:^{
            _searchCoverView.alpha = 0.0;
        }];
        _searchCoverView.userInteractionEnabled = NO;
    }else {
        [UIView animateWithDuration:0.25 animations:^{
            _searchCoverView.alpha = 0.7;
        }];
        _searchCoverView.userInteractionEnabled = YES;
    }
    
    [self searchRecords:searchText];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    _inSearchStatus = YES;
    if (searchBar.text.length == 0) {
        [UIView animateWithDuration:0.25 animations:^{
            _searchCoverView.alpha = 0.7;
        }];
        _searchCoverView.userInteractionEnabled = YES;
    }
    searchBar.showsCancelButton = YES;
    return true;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    _inSearchStatus = NO;
    [searchBar resignFirstResponder];
    [self initTableViewData];
    searchBar.showsCancelButton = NO;
    searchBar.text = @"";
    
    [UIView animateWithDuration:0.25 animations:^{
        _searchCoverView.alpha = 0.0;
    }];
    _searchCoverView.userInteractionEnabled = NO;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    _searchCoverView.userInteractionEnabled = NO;
    searchBar.showsCancelButton = NO;
}

-(void)searchRecords:(NSString *)keyword{
    NSString *sql = [NSString stringWithFormat:@"select *,rowid from %@ where %@ like '%%%@%%' or %@ like '%%%@%%' or %@ like '%%%@%%' or %@ like '%%%@%%' or %@ like '%%%@%%' order by %@ desc",TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_ORDER_TYPE,keyword,APPROVE_PROPERTY_INSTANCE_DESC,keyword,APPROVE_PROPERTY_NODE_NAME,keyword,APPROVE_PROPERTY_EMPLOYEE_NAME,keyword,APPROVE_PROPERTY_CREATION_DATE,keyword,APPROVE_PROPERTY_CREATION_DATE];
    
    [_dbHelper.db open];
    FMResultSet *resultSet = [_dbHelper.db executeQuery:sql];
    NSMutableArray *resultObjs = [NSMutableArray array];
    while (resultSet.next) {
        Approve *a= [[Approve alloc]initWithRowId:[resultSet objectForColumnName:@"rowid"] workflowId:[resultSet objectForColumnName:APPROVE_PROPERTY_WORKFLOW_ID] recordId:[resultSet objectForColumnName:APPROVE_PROPERTY_RECORD_ID] nodeId:[resultSet objectForColumnName:APPROVE_PROPERTY_NODE_ID] instanceId:[resultSet objectForColumnName:APPROVE_PROPERTY_INSTANCE_ID] orderType:[resultSet stringForColumn:APPROVE_PROPERTY_ORDER_TYPE] instanceDesc:[resultSet stringForColumn:APPROVE_PROPERTY_INSTANCE_DESC] instanceParam:[resultSet objectForColumnName:APPROVE_PROPERTY_INSTANCE_PARAM] nodeName:[resultSet stringForColumn:APPROVE_PROPERTY_NODE_NAME] employeeName:[resultSet stringForColumn:APPROVE_PROPERTY_EMPLOYEE_NAME] creationDate:[resultSet stringForColumn:APPROVE_PROPERTY_CREATION_DATE] dateLimit:[resultSet stringForColumn:APPROVE_PROPERTY_DATE_LIMIT] isLate:[resultSet objectForColumnName:APPROVE_PROPERTY_IS_LATE] screenName:[resultSet stringForColumn:APPROVE_PROPERTY_SCREEN_NAME] localStatus:[resultSet stringForColumn:APPROVE_PROPERTY_LOCAL_STATUS] comment:[resultSet stringForColumn:APPROVE_PROPERTY_COMMENT] actionType:[resultSet stringForColumn:APPROVE_PROPERTY_APPROVE_ACTION] serverMessage:[resultSet stringForColumn:APPROVE_PROPERTY_SERVER_MESSAGE] submitUrl:[resultSet stringForColumn:APPROVE_PROPERTY_SUBMIT_URL]];
        [resultObjs addObject:a];
        [a release];
    }
    self.tableAdapter.approveArray = resultObjs;
    [self.tableView reloadData];
}

@end
