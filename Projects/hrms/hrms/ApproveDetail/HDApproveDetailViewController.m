//
//  ApproveDetailViewController.m
//  hrms
//
//  Created by Rocky Lee on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDApproveDetailViewController.h"
#import "Approve.h"

@implementation HDApproveDetailViewController

@synthesize webPage = _webPage;
@synthesize toolbar = _toolbar;
@synthesize detailModel = _detailModel;
@synthesize loadType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithName:(NSString *) name 
            query:(NSDictionary *) query
{
    self = [super init];
    if (self) {
        Approve * approve = [query objectForKey:HD_APPROVE_DATA];
//        NSUInteger theRecordID = approve.recordId;
//        NSString * theScreenName = approve.screenName;
        
//        self.detailModel = [[HDApproveDetailModel alloc]initWithRecordID:[NSNumber numberWithInt:theRecordID]
//                                                               screenName:theScreenName];
        self.detailModel = [[HDApproveDetailModel alloc]initWithApprove:approve];
        self.title = name;
        self.loadType = HD_LOAD_WITHOUT_ACTION;
        if (approve.localStatus == @"NORMAL") {
            self.loadType = HD_LOAD_WITH_ACTION;
        }
    }
    return self;
}

- (void)dealloc 
{
    TT_RELEASE_SAFELY(_webPage);
    TT_RELEASE_SAFELY(_toolbar);
    TT_RELEASE_SAFELY(_detailModel);
    [_detailModel loadCancel];
    [super dealloc];
}

#pragma -mark 提交窗口协议
-(void)ApproveOpinionViewDismissed:(int)resultCode messageDictionary:(NSDictionary *)dictionary
{
    //解除模态视图
    [self dismissModalViewControllerAnimated:YES];
    if (resultCode == RESULT_OK) {
//        //开启遮罩
//        [self addActivityLabelWithStyle:TTActivityLabelStyleWhite];
//        //提交
//        [_detailModel setComment:[dictionary objectForKey:@"comment"]];
//        [_detailModel execAction];
        //TODO:直接回去
        [_detailModel setComment:[dictionary objectForKey:@"comment"]];
        [_detailModel execAction];
        [self.navigationController popViewControllerAnimated:YES];
        //发送提交审批的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"detailApproved" object:nil];
    }
}

#pragma -mark webview和toolbar数据协议
-(void) webPageLoad:(ASIHTTPRequest *)theRequest responseString:(NSString *)htmlString
{
    [self.webPage loadHTMLString:htmlString baseURL:[theRequest url]];
}

-(void) actionLoad:(NSArray *) dataSet
{
    //    NSLog(@"HDApproveDetailViewController.m -48 line \n\n %@,%i",NSStringFromSelector(_cmd),[dataSet count]);
    NSMutableArray * toolbarItems = [[NSMutableArray alloc]init];
    
    for (NSDictionary * actionRecord in dataSet) {
        [actionRecord valueForKey:@"action_title"];
        UIBarButtonItem * action = [[UIBarButtonItem alloc]initWithTitle:[actionRecord valueForKey:@"action_title"] 
                                                                   style:UIBarButtonItemStyleBordered 
                                                                  target:self 
                                                                  action:@selector(actionBrtPressed:)];
        [action setTag:[[actionRecord objectForKey:@"action_id"]integerValue]];
        [toolbarItems addObject:action];
        TT_RELEASE_SAFELY(action);
        UIBarButtonItem * flexibleSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [toolbarItems addObject:flexibleSpace];
        TT_RELEASE_SAFELY(flexibleSpace);
    }
    
    [toolbarItems removeLastObject];    
    [_toolbar setItems:toolbarItems animated:YES];
    TT_RELEASE_SAFELY(toolbarItems);
}

-(void)actionBrtPressed: (id)sender
{
    [_detailModel setActionID:[NSString stringWithFormat:@"%i",[sender tag]]];
    
    ApproveOpinionView * opinionViewController = [[[ApproveOpinionView alloc]initWithNibName:@"ApproveOpinionView" bundle:nil] autorelease];
    [opinionViewController setControllerDelegate:self];
    [self presentModalViewController:opinionViewController animated:YES];
}

//#pragma -mark 提交时遮罩
//- (void)addActivityLabelWithStyle:(TTActivityLabelStyle)style
//{
//    UIView *backView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
//    backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
//    backView.tag = BACK_VIEW;
//    
//    TTActivityLabel* label = [[[TTActivityLabel alloc] initWithStyle:style] autorelease];
//    label.text = @"Loading...";
//    [label sizeToFit];
//    label.frame = CGRectMake(0, 180, self.view.width, label.height);
//    label.tag = ACTIVE_LABEL;
//    
//    [backView addSubview:label];
//    [self.navigationController.view addSubview:backView];
//}

//-(void) removeActivityLabel
//{
//    [[self.navigationController.view viewWithTag:BACK_VIEW]removeFromSuperview];
//}

////提交成功,退回列表
//-(void) execActionSuccess:(NSArray *) dataSet
//{
//    [self removeActivityLabel];
//    [self.navigationController popViewControllerAnimated:YES];
//}

////提交失败,弹出对话框
//-(void) execActionFailed: (NSString *) errorMessage
//{
//    [self removeActivityLabel];
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"失败" 
//                                                    message:errorMessage 
//                                                   delegate:nil 
//                                          cancelButtonTitle:@"确定" 
//                                          otherButtonTitles:nil];
//    [alert show];
//    TT_RELEASE_SAFELY(alert);
//}

#pragma -mark 页面load事件
- (void)viewDidLoad
{
    [super viewDidLoad];  
     
}

- (void)viewDidUnload
{
    TT_RELEASE_SAFELY(_webPage);
    TT_RELEASE_SAFELY(_toolbar);
    TT_RELEASE_SAFELY(_detailModel);
    [_detailModel loadCancel];
    [super viewDidUnload];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_detailModel setDelegate:self];
    if (self.loadType == HD_LOAD_WITH_ACTION) {
        [_detailModel loadWebActions];
    }
    
    [_detailModel loadWebPage];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
