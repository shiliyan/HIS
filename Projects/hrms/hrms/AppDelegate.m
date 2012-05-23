//
//  AppDelegate.m
//  hrms
//
//  Created by Rocky Lee on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

//styleSheet
#import "MyStyleSheet.h"

#import "HDClassLoader.h"
@implementation AppDelegate

NSString * kLoginPathName =@"HD_LOGIN_VC_PATH";
NSString * kMainPathName =@"HD_MAIN_VC_PATH";

-(void) applicationDidFinishLaunching:(UIApplication *)application
{
    //register notification
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
    
    //配置首选项
    [self setupByPreferences];
    
    //注册显示登陆
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backToLoginView) name:@"show_login_view" object:nil];
    
    //Views Managment by Three20
    [TTStyleSheet setGlobalStyleSheet:[[[TTDefaultStyleSheet alloc]init]autorelease]];
      
    if(![[HDNavigator navigator] restoreViewControllers])
    {      
        [self showLoginView];
    }
    
}

-(void)showLoginView
{
    HDNavigator* navigator = [HDNavigator navigator];
    NSString * kMainViewControllerPathPath = [[HDGodXMLFactory shareBeanFactory] actionURLPathWithKey:kMainPathName];
    
    NSString * kLoginViewControllerPath = [[HDGodXMLFactory shareBeanFactory] actionURLPathWithKey:kLoginPathName];

    if (!kMainViewControllerPathPath || !kLoginViewControllerPath) {
        //如果没有配置,弹默认视图
        [self showErrorView];
    }else {
    [navigator openURLAction:[TTURLAction actionWithURLPath:kMainViewControllerPathPath]];
       
    [navigator openURLAction:[TTURLAction actionWithURLPath:kLoginViewControllerPath]];
    }
}

-(void)reloadConfig
{
    HDClassLoader * classLoader = [[HDClassLoader alloc]init];
    [classLoader startLoadClass];
    TT_RELEASE_SAFELY(classLoader);
    [self showLoginView];
}

-(void)showErrorView
{
    TTErrorView* errorView = [[[TTErrorView alloc] initWithTitle:@"无法获取运行配置"
                                                        subtitle:@"请检查网络设置和系统设置中的服务地址是否正确"
                                                           image:[UIImage imageNamed:@"network_server.png"]] 
                              autorelease];
    
        [errorView addReloadButton];
        [errorView.reloadButton addTarget:self
                                   action:@selector(reloadConfig)
                         forControlEvents:UIControlEventTouchUpInside];
    
    errorView.backgroundColor = TTSTYLEVAR(backgroundColor);
    errorView.frame = TTScreenBounds();
    
    errorView.tag = 7;
    UIWindow * window = [HDNavigator navigator].window;
    UIView * oldErrorView = [window viewWithTag:7];
    if (!oldErrorView) {
        [window addSubview:errorView];
    }
}

-(void)backToLoginView
{
//    TTAlert(@"登录超时");
    HDNavigator* navigator = [HDNavigator navigator];
    [navigator removeAllViewControllers];
    [self showLoginView];
}

//初始化偏好设置
- (void)setupByPreferences
{
    NSString *baseURL = [[NSUserDefaults standardUserDefaults] stringForKey:@"base_url_preference"];
    NSString *defaultApprove = [[NSUserDefaults standardUserDefaults] stringForKey:@"default_approve_preference"];
	if (!baseURL||!defaultApprove)
	{
        //从root文件读取配置
        NSString *settingsBundlePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Settings.bundle"];
        
        NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
        NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
        
        NSArray *prefSpecifierArray = [settingsDict objectForKey:@"PreferenceSpecifiers"];
        
        NSMutableDictionary *appDefaults = [NSMutableDictionary dictionary];
        for (NSDictionary *prefItem in prefSpecifierArray)
        {
            if ([prefItem objectForKey:@"DefaultValue"] != nil) {
                [appDefaults setValue:[prefItem objectForKey:@"DefaultValue"] 
                               forKey:[prefItem objectForKey:@"Key"]];
            }
        }
        
        [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
        [[NSUserDefaults standardUserDefaults] synchronize];
	}
}

//获取token成功,格式化token,放入用户设置中
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //get the deivcetoken
    NSLog(@"My token is: %@", deviceToken);
    NSLog(@"%@",[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]); 
    
    //format token
    NSString *tokenWithBlank = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSString *tokenWithoutBlank = [tokenWithBlank stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //save deviceToken to userDefaults
    [[NSUserDefaults standardUserDefaults] setValue:tokenWithoutBlank forKey:@"deviceToken"];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Error in registration.Error: %@" ,error);
    [[NSUserDefaults standardUserDefaults] setValue:@"null" forKey:@"deviceToken"];
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"无法设置推送请检查网络是否可用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alert show];
//    [alert release];
}

#pragma -mark 程序进入后台或激活时触发事件，用于保存数据，处理程序重新进入后的初始化
-(void) applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"Kill");
}

@end
