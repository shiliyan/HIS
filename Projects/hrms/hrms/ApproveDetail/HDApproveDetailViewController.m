//
//  ApproveDetailViewController.m
//  hrms
//
//  Created by Rocky Lee on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDApproveDetailViewController.h"

@implementation HDApproveDetailViewController

@synthesize webPage = _webPage;
@synthesize toolbar = _toolbar;
@synthesize approveModel = _approveModel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithName:(NSString *) name 
         recordID:(NSInteger) theRecordID 
       screenName:(NSString *) theScreenName
{
    self = [super init];
    if (self) {
        self.approveModel = [[HDApproveDetailModel alloc]initWithRecordID:[NSNumber numberWithInt: theRecordID ]
                                                               screenName:theScreenName];
        self.title = name;
    }
    return self;
}

- (void)dealloc 
{
    TT_RELEASE_SAFELY(_webPage);
    TT_RELEASE_SAFELY(_toolbar);
    TT_RELEASE_SAFELY(_approveModel);
    [_approveModel loadCancel];
    [super dealloc];
}

#pragma -mark 提交窗口协议
-(void)ApproveOpinionViewDismissed:(int)resultCode messageDictionary:(NSDictionary *)dictionary
{
    //解除模态视图
    [self dismissModalViewControllerAnimated:YES];
    if (resultCode == RESULT_OK) {
        //开启遮罩
//        [self addActivityLabelWithStyle:TTActivityLabelStyleWhite];
        //提交
        [_approveModel setComment:[dictionary objectForKey:@"comment"]];
        [_approveModel execAction];
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
    [_approveModel setActionID:[NSNumber numberWithInteger:[sender tag]]];
       
        ApproveOpinionView * opinionViewController = [[[ApproveOpinionView alloc]initWithNibName:@"ApproveOpinionView" bundle:nil] autorelease];
        [opinionViewController setControllerDelegate:self];
        [self presentModalViewController:opinionViewController animated:YES];
}
#pragma -mark 提交时遮罩
//- (void)addActivityLabelWithStyle:(TTActivityLabelStyle)style{
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

#pragma -mark 提交成功失败回调
//-(void) doActionSuccess:(NSArray *) dataSet
//{
//    //写数据库
//    //初始化数据库连接
//    dbHelper = [[ApproveDatabaseHelper alloc]init];
//    
//    [dbHelper.db open];
//    NSString * sql = [NSString stringWithFormat:@"delete from %@ where %@ = %i",@"approve_list",@"record_id",self.approveDetailRecord.recordID];
//    NSLog(@"%@",sql);
//    [dbHelper.db executeUpdate:sql];
//    [dbHelper.db close];
//    
//    [dbHelper release];
//    //解除遮罩
//    [[self.navigationController.view viewWithTag:BACK_VIEW]removeFromSuperview];
//    
//    //退回到待办事项列表
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//-(void) doActionError:(NSString *) msg
//{
//    //解除遮罩
//    [[self.navigationController.view viewWithTag:BACK_VIEW]removeFromSuperview];
//}
//
//-(void) doActionASIFailed:(ASIHTTPRequest *) theRequest
//{
//    //解除遮罩
//    [[self.navigationController.view viewWithTag:BACK_VIEW]removeFromSuperview];
//}
//
//-(void) doActionServerError:(NSString *)msg
//{
//    //解除遮罩
//    [[self.navigationController.view viewWithTag:BACK_VIEW]removeFromSuperview];
//}

#pragma -mark webView的代理方法
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    return YES;
//}
//
////页面加载开始
//- (void)webViewDidStartLoad:(UIWebView *)webView{
//    
//}
//
////页面加载完成
//- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    
//}
//
////页面加载失败
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    
//}

#pragma -mark 页面load事件
- (void)viewDidLoad
{
    [super viewDidLoad];  
    [_approveModel setDelegate:self];
    [_approveModel loadWebPage];
    [_approveModel loadWebActions];
}

- (void)viewDidUnload
{
    TT_RELEASE_SAFELY(_webPage);
    TT_RELEASE_SAFELY(_toolbar);
    TT_RELEASE_SAFELY(_approveModel);
    [_approveModel loadCancel];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
