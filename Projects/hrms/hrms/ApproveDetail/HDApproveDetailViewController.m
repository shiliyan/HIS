//
//  ApproveDetailViewController.m
//  hrms
//
//  Created by Rocky Lee on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDApproveDetailViewController.h"
#import "Approve.h"
#import "HDApproveActions.h"

@implementation HDApproveDetailViewController

@synthesize webPage = _webPage;
@synthesize toolbar = _toolbar;
@synthesize detailModule = _detailModel;
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
//        
//        HDApprove * hdApprove = [[HDApprove alloc]init];
//        hdApprove.rowID = [NSNumber numberWithInt:approve.rowId];
//        hdApprove.recordID = [NSNumber numberWithInt:approve.recordId];
//        hdApprove.workflowID = [NSNumber numberWithInt:approve.workflowId];
//        hdApprove.action = approve.action;
//        hdApprove.nodeName = approve.nodeName;
//        hdApprove.workflowName = approve.workflowName;
//        hdApprove.workflowDesc = approve.workflowDesc;
//        hdApprove.employeeName = approve.employeeName;
//        hdApprove.creationDate = approve.creationDate;
//        hdApprove.dateLimit = approve.dateLimit;
//        hdApprove.isLate = [NSNumber numberWithInt:approve.isLate];
//        hdApprove.screenName = approve.screenName;
//        hdApprove.localStatus = approve.localStatus;
//        hdApprove.comment = approve.comment;
//        hdApprove.serverMessage = approve.serverMessage;
//        hdApprove.submitURL = approve.submitUrl;
        
        
        //        self.detailModel = [[HDApproveDetailModel alloc]initWithApprove:hdApprove];
        self.detailModule = [[HDApproveModule alloc]initWithApproveModule:approve];
        [self.detailModule setActions:[HDApproveActions actionsModule]];
        
        self.title = approve.workflowName;
//        self.loadType = HD_APPROVE_ERROR;
//        if ([approve.localStatus isEqualToString: @"NORMAL"]) {
//            self.loadType = HD_APPROVE_NORMAL;
//        }
//        if ([approve.localStatus isEqualToString:@"DIFFERENT"]) {
//            self.loadType = HD_APPROVE_EXCEPTION;
//        }
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
        [_detailModel.approveEntity setComment:[dictionary valueForKey:@"comment"]];
        
        
        //        [_detailModel setComment:[dictionary objectForKey:@"comment"]];
        //        [_detailModel execAction];
        [self.navigationController popViewControllerAnimated:YES];
        //发送提交审批的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"detailApproved" object:nil];
    }
}

#pragma -mark webview和toolbar数据协议
-(void) webPageLoad:(NSString *)htmlString baseURL:(NSURL *)theBaseURL
{
    [self.webPage loadHTMLString:htmlString baseURL:theBaseURL];
}

-(void) actionLoad:(NSArray *)actionArray
{
    //    NSLog(@"HDApproveDetailViewController.m -48 line \n\n %@,%i",NSStringFromSelector(_cmd),[actionArray count]); 
    NSMutableArray * toolbarItems = [[NSMutableArray alloc]init];       
    for (NSDictionary * actionRecord in actionArray) {
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
    [_detailModel.approveEntity setAction:[NSString stringWithFormat:@"%i",[sender tag]]];
    
    ApproveOpinionView * opinionViewController = [[[ApproveOpinionView alloc]initWithNibName:@"ApproveOpinionView" bundle:nil] autorelease];
    [opinionViewController setControllerDelegate:self];
    [self presentModalViewController:opinionViewController animated:YES];
}

#pragma -mark 页面load事件
- (void)viewDidLoad
{
    [super viewDidLoad]; 
    [_detailModel setDelegate:self];
    [_detailModel startLoad];
}

- (void)viewDidUnload
{
    [_detailModel loadCancel];
    TT_RELEASE_SAFELY(_webPage);
    TT_RELEASE_SAFELY(_toolbar);
    TT_RELEASE_SAFELY(_detailModel);
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
