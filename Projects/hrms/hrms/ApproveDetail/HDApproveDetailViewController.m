//
//  ApproveDetailViewController.m
//  hrms
//
//  Created by Rocky Lee on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDApproveDetailViewController.h"
#import "ApproveOpinionView.h"

@interface HDApproveDetailViewController ()
-(void)setActionToolbar:(NSMutableArray *)dataSet;
@end

@implementation HDApproveDetailViewController

@synthesize approveDetailRecord;
@synthesize submitAction;

@synthesize webPageRequest;
@synthesize toolBarDataRequest;
@synthesize actionRequest;

static NSString * kBaseUrl = @"http://10.213.208.66:8080/hr_new/modules/ios/IOS_APPROVE/";
static NSString * kToolBarActionUrl = @"http://10.213.208.66:8080/hr_new/autocrud/ios.IOS_APPROVE.ios_workflow_approve_action_query/query";
static NSString * kDoActionUrl = @"http://10.213.208.66:8080/hr_new/autocrud/ios.IOS_APPROVE.ios_workflow_approve_action_submit/update";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithName:(NSString*) name query:(NSDictionary*) record
{
    self = [super init];
    if (self) {
        self.approveDetailRecord = [record objectForKey:@"detailRecord"];
        
        self.submitAction = [NSMutableDictionary dictionaryWithObject: [NSNumber numberWithInteger: self.approveDetailRecord.recordId ] forKey:@"record_id"];
        
        self.title = approveDetailRecord.nodeName;
    }
    return self;
}

- (void)dealloc 
{
//    [[TTNavigator navigator].URLMap removeURL:@"tt://actionCommentView"];
    [webPageRequest clearDelegatesAndCancel];
    TT_RELEASE_SAFELY(actionRequest);
    TT_RELEASE_SAFELY(toolBarDataRequest);
    TT_RELEASE_SAFELY(webPageRequest);
    [super dealloc];
}

#pragma -mark 提交时遮罩
- (void)addActivityLabelWithStyle:(TTActivityLabelStyle)style{
    UIView *backView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
    backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    backView.tag = BACK_VIEW;
    
    TTActivityLabel* label = [[[TTActivityLabel alloc] initWithStyle:style] autorelease];
    label.text = @"Loading...";
    [label sizeToFit];
    label.frame = CGRectMake(0, 180, self.view.width, label.height);
    label.tag = ACTIVE_LABEL;
    
    [backView addSubview:label];
    [self.view addSubview:backView];
}


-(void)ApproveOpinionViewDismissed:(int)resultCode messageDictionary:(NSDictionary *)dictionary
{
    if (resultCode == RESULT_OK) {
        //开启遮罩
        [self addActivityLabelWithStyle:TTActivityLabelStyleWhite];
        //提交
        [self dismissModalViewControllerAnimated:YES];
        [self.submitAction setObject:[dictionary objectForKey:@"comment"] forKey:@"comment"];
        
        //TODO:未开启网络提交　　
        /*
        self.actionRequest  = [HDFormDataRequest hdRequestWithURL:kDoActionUrl 
                                                              withData:self.submitAction
                                                               pattern:HDrequestPatternNormal];
        
        [toolBarDataRequest setDelegate:self];
        [toolBarDataRequest setSuccessSelector:@selector(doAdctionSuccess:)];
        [toolBarDataRequest startAsynchronous];
        */
    }else {
        //解除模态视图
        [self dismissModalViewControllerAnimated:YES];
    }
}

#pragma -mark 设置工具栏动作
-(void)setActionToolbar:(NSMutableArray *)dataSet
{
    //    NSLog(@"HDApproveDetailViewController.m -48 line \n\n %@,%i",NSStringFromSelector(_cmd),[dataSet count]);
    NSMutableArray * toolbarItems = [[NSMutableArray alloc]init];
    
    for (NSDictionary * actionRecord in dataSet) {
        [actionRecord valueForKey:@"action_title"];
        UIBarButtonItem * action = [[UIBarButtonItem alloc]initWithTitle:[actionRecord valueForKey:@"action_title"] 
                                                                   style:UIBarButtonItemStyleBordered 
                                                                  target:self 
                                                                  action:@selector(doAction:)];
        [action setTag:[[actionRecord objectForKey:@"action_id"]integerValue]];
        [toolbarItems addObject:action];
        TT_RELEASE_SAFELY(action);
        UIBarButtonItem * flexibleSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [toolbarItems addObject:flexibleSpace];
        TT_RELEASE_SAFELY(flexibleSpace);
    }
    
    [toolbarItems removeLastObject];
    
    [toolbar setItems:toolbarItems animated:YES];
    TT_RELEASE_SAFELY(toolbarItems);
}

-(void)doAction:(id)sender
{

    [self.submitAction setObject:[NSNumber numberWithInteger:[sender tag]] forKey:@"action_id"];
    
    ApproveOpinionView * opinionViewController = [[[ApproveOpinionView alloc]initWithNibName:@"ApproveOpinionView" bundle:nil] autorelease];
    [opinionViewController setControllerDelegate:self];
    opinionViewController.opinionTextView.text = @"可，同意";
    [self presentModalViewController:opinionViewController animated:YES];
}

-(void) doAdctionSuccess:(NSArray *) dataSet
{
    //TODO:@~@
    //解除遮罩
    [[self.view viewWithTag:BACK_VIEW]removeFromSuperview];
    //退回到待办事项列表
    //写数据库
    
    [[TTNavigator navigator].topViewController.navigationController popViewControllerAnimated:YES];
}

#pragma -mark web Page load callback functions  
- (void)webPageLoadFailed:(ASIHTTPRequest *)theRequest
{
	NSLog(@"%@",[NSString stringWithFormat:@"Something went wrong: %@",[theRequest error]]);
}

- (void)webPageLoadSucceeded:(ASIHTTPRequest *)theRequest
{
	
    NSURL *baseURL;
    //	if ([replaceURLsSwitch isOn]) {
    baseURL = [theRequest url];
    
    if([theRequest responseStatusCode] == 404)
    {
        [webView loadHTMLString:@"<h1>ERROR</h1><br/><h1>404</h1>" baseURL:baseURL];
    }
    
    if([theRequest responseStatusCode] == 500)
    {
        [webView loadHTMLString:@"<h1>ERROR</h1><br/><h1>500</h1>" baseURL:baseURL];
    }
    
    // If we're using ASIReplaceExternalResourcesWithLocalURLs, we must set the baseURL to point to our locally cached file
    //	} else {
    //		baseURL = [NSURL fileURLWithPath:[request downloadDestinationPath]];
    //	}
    if([theRequest responseStatusCode] == 200)
    {
        if ([theRequest downloadDestinationPath])
        {
            NSString *response = [NSString stringWithContentsOfFile:[theRequest downloadDestinationPath] encoding:[theRequest responseEncoding] error:nil];
            //		[responseField setText:response];
            [webView loadHTMLString:response baseURL:baseURL];
        } else {
            //		[responseField setText:[theRequest responseString]];
            [webView loadHTMLString:[theRequest responseString] baseURL:baseURL];
        }
    }
	
    //	[urlField setText:[[theRequest url] absoluteString]];
}

#pragma -mark webView的代理方法
//这个什么玩意啊
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

//页面加载开始
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

//页面加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}

//页面加载失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

#pragma -mark 页面load事件
- (void)viewDidLoad
{
    [super viewDidLoad];    
    //request a bm to get the bar item button's actions
    //TODO:Approve对象缺少toDataSet方法
    /*
     *这里暂时取出record_id拼接一个record_id
     */
    
    NSLog(@"HDAppreoveDetailController -152 \n\n%i",self.approveDetailRecord.recordId);
    NSDictionary * data = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:self.approveDetailRecord.recordId] forKey:@"record_id"];
    //////////////////////////////////////
    self.toolBarDataRequest = [HDFormDataRequest hdRequestWithURL:kToolBarActionUrl 
                                                      withData:data
                                                       pattern:HDrequestPatternNormal];
    
    [toolBarDataRequest setSuccessSelector: @selector(setActionToolbar:)];
    [toolBarDataRequest setDelegate:self];
    [toolBarDataRequest startAsynchronous];
    
    //   [self formRequest:@"" withData:[approveRecord toDataSet] successSelector:@selector(setToolbar:) failedSelector:nil errorSelector:nil noNetworkSelector:nil];
    
    //request a screen to get the approve detail view
    //    NSLog(@"%@",[NSString stringWithFormat:@"%@%@?record_id=%i",kBaseUrl , self.approveDetailRecord.screenName,approveDetailRecord.recordId]);
    NSString * screenUrl = [NSString stringWithFormat:@"%@%@?record_id=%i",kBaseUrl , self.approveDetailRecord.screenName,approveDetailRecord.recordId];
    
    self.webPageRequest = [ASIWebPageRequest requestWithURL:[NSURL URLWithString:screenUrl]];
    [self requestConfig:HDrequestPatternNormal];
	[webPageRequest setDidFailSelector:@selector(webPageLoadFailed:)];
	[webPageRequest setDidFinishSelector:@selector(webPageLoadSucceeded:)];
	[webPageRequest setDelegate:self];
	[webPageRequest setDownloadProgressDelegate:self];
    [webPageRequest startAsynchronous];
}

#pragma -mark 配置webPageRequest
-(void) requestConfig:(NSInteger) pattern
{
    [webPageRequest setDelegate:nil];
    //[webPageRequest cancel];
    
    [webPageRequest setUrlReplacementMode:ASIReplaceExternalResourcesWithData];
    
    // It is strongly recommended that you set both a downloadCache and a downloadDestinationPath for all ASIWebPageRequests
	[webPageRequest setDownloadCache:[ASIDownloadCache sharedCache]];
    /*
     *Q:这里是缓存策略，设置为不从缓存读取 ASIDoNotReadFromCacheCachePolicy
     */
	[webPageRequest setCachePolicy:ASIDoNotReadFromCacheCachePolicy|ASIDoNotWriteToCacheCachePolicy];
    
	// This is actually the most efficient way to set a download path for ASIWebPageRequest, as it writes to the cache directly
	[webPageRequest setDownloadDestinationPath:[[ASIDownloadCache sharedCache] pathToStoreCachedResponseDataForRequest:webPageRequest]];
	
	[[ASIDownloadCache sharedCache] setShouldRespectCacheControlHeaders:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [webPageRequest clearDelegatesAndCancel];
    TT_RELEASE_SAFELY(webPageRequest);
    TT_RELEASE_SAFELY(toolBarDataRequest);
    TT_RELEASE_SAFELY(actionRequest);
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma -mark lab
-(void)query
{
    UIBarButtonItem * action = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:nil action:@selector(query)];
    
    NSMutableArray * toolbarItems = [NSMutableArray arrayWithArray:[toolbar items]];
    
    [toolbarItems addObject:action];
    [action release];
    
    [toolbar setItems:toolbarItems animated:YES];
    //
    [webView stringByEvaluatingJavaScriptFromString:@"document.forms[0].submit(); "];
}

@end
