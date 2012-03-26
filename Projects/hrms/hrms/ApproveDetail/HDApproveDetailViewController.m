//
//  ApproveDetailViewController.m
//  hrms
//
//  Created by Rocky Lee on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDApproveDetailViewController.h"


@interface HDApproveDetailViewController ()
-(void)setActionToolbar:(NSMutableArray *)dataSet;
@end

@implementation HDApproveDetailViewController

@synthesize approveDetailRecord;
@synthesize webPageRequest;
@synthesize formDataRequest;

static NSString * kDetailUrl = @"http://www.google.com.hk/";
static NSString * kToolBarActionUrl = @"http://localhost:8080/hr_new/autocrud/ios.IOS_APPROVE.ios_workflow_approve_action_query/query";
static NSString * kDoActionUrl = @"http://localhost:8080/hr_new/autocrud/ios.IOS_APPROVE.ios_workflow_approve_action_submit/update";

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
        self.title = name;
        self.approveDetailRecord = [record objectForKey:@"detailRecord"];
    }
    return self;
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
    }
    
    [toolbar setItems:toolbarItems animated:YES];
    TT_RELEASE_SAFELY(toolbarItems);
}

-(void)doAction:(id)sender
{
    NSLog(@"%i",[sender tag]);
    NSMutableDictionary * action = [NSMutableDictionary dictionaryWithObject:@"update" forKey:@"_status"];
    [action setValue:[NSNumber numberWithInteger:[sender tag]] forKey:@"action_id"];
    [action setValue:@"可" forKey:@"comment"];
    [action setValue:[NSNumber numberWithInteger: self.approveDetailRecord.recordId ] forKey:@"record_id"];
    
    
    self.formDataRequest  = [HDFormDataRequest hdRequestWithURL:kDoActionUrl 
                                                       withData:action
                                                        pattern:HDrequestPatternNormal];
    
    [formDataRequest setDelegate:self];
    [formDataRequest setSuccessSelector:@selector(doAdctionSuccess:)];
    [formDataRequest startAsynchronous];
}

-(void) doAdctionSuccess:(NSArray *) dataSet
{
    //退回到待办事项列表
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
    
    // If we're using ASIReplaceExternalResourcesWithLocalURLs, we must set the baseURL to point to our locally cached file
    //	} else {
    //		baseURL = [NSURL fileURLWithPath:[request downloadDestinationPath]];
    //	}
    
	if ([theRequest downloadDestinationPath]) {
		NSString *response = [NSString stringWithContentsOfFile:[theRequest downloadDestinationPath] encoding:[theRequest responseEncoding] error:nil];
        //		[responseField setText:response];
		[webView loadHTMLString:response baseURL:baseURL];
	} else {
        //		[responseField setText:[theRequest responseString]];
		[webView loadHTMLString:[theRequest responseString] baseURL:baseURL];
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
    
    NSLog(@"HDAppreoveDetailController -133 \n\n%i",self.approveDetailRecord.recordId);
    NSDictionary * data = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:self.approveDetailRecord.recordId] forKey:@"record_id"];
    //////////////////////////////////////
    self.formDataRequest = [HDFormDataRequest hdRequestWithURL:kToolBarActionUrl 
                                                      withData:data
                                                       pattern:HDrequestPatternNormal];
    
    [formDataRequest setSuccessSelector: @selector(setActionToolbar:)];
    [formDataRequest setDelegate:self];
    [formDataRequest startAsynchronous];
    
    //   [self formRequest:@"" withData:[approveRecord toDataSet] successSelector:@selector(setToolbar:) failedSelector:nil errorSelector:nil noNetworkSelector:nil];
    //request a screen to get the approve detail view
    NSString * base_url = @"http://localhost:8080/hr_new/modules/ios/IOS_APPROVE/BX_ReimbursementWorkFlow.screen";
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",base_url , self.approveDetailRecord.screenName]);
//    NSString * screenUrl = [NSString stringWithFormat:@"%@%@",base_url , self.approveDetailRecord.screenName];
    
    self.webPageRequest = [ASIWebPageRequest requestWithURL:[NSURL URLWithString:base_url]];
    [self requestConfig:0];
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
