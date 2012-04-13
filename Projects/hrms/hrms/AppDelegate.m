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
//view controllers
#import "RCLoginViewController.h"
//审批
#import "ApproveListController.h"
//审批明细
#import "HDApproveDetailViewController.h"

@implementation AppDelegate

-(void) applicationDidFinishLaunching:(UIApplication *)application
{
    //register notification
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
    
    //配置首选项
    [self setupByPreferences];
    
    //注册显示登陆
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showLoginView:) name:@"show_login_view" object:nil];
    
    //Views Managment by Three20
    TTNavigator* navigator = [TTNavigator navigator]; 
    
    [self initViewControllers:navigator];
    
    if(![navigator restoreViewControllers])
    {
        //        NSLog(@"No RestoreViewCtrl!!");
        [navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://approve"]];
        
        [navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://login"]applyTransition:UIViewAnimationTransitionFlipFromLeft]];
    }
    
}

-(void) initViewControllers:(TTNavigator *) navigator
{   
    navigator.persistenceMode = TTNavigatorPersistenceModeNone;
    
    navigator.window = [[[UIWindow alloc] initWithFrame:TTScreenBounds()] autorelease];
    
    [TTStyleSheet setGlobalStyleSheet:[[[MyStyleSheet alloc]init]autorelease]];
    
    TTURLMap* map = navigator.URLMap;
    
    // Any URL that doesn't match will fall back on this one, and open in the web browser
    [map from:@"*" toViewController:[TTWebController class]]; 
    
    //login view
    [map from:@"tt://login" 
toModalViewController:[RCLoginViewController class]];
    
    //审批
    [map from:@"tt://approve" 
toSharedViewController:[ApproveListController class]];
    
    //审批明细
    [map from:@"tt://approve_detail/(initWithName:)/(recordID:)/(screenName:)/(loadType:)" 
       parent:@"tt://approve" 
toViewController:[HDApproveDetailViewController class] 
     selector:nil 
   transition:0];

}

-(void)showLoginView:(id)sender
{
    NSLog(@"catch");
    //TODO:弹出登录界面,session失效时触发
    TTNavigator* navigator = [TTNavigator navigator];
    [navigator openURLAction:[[[TTURLAction actionWithURLPath:@"tt://login"]applyTransition:UIViewAnimationTransitionFlipFromLeft] applyAnimated:YES]];
}

//初始化偏好设置
- (void)setupByPreferences
{
    NSString *baseURL = [[NSUserDefaults standardUserDefaults] stringForKey:@"base_url_preference"];
	if (nil == baseURL)
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
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"无法设置推送请检查网络是否可用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    [alert release];
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
