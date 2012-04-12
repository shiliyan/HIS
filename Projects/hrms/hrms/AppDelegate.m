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
//
#import "HDURLCenter.h"
//view controllers
#import "RCLoginViewController.h"
//审批
#import "ApproveListController.h"
//审批明细
#import "HDApproveDetailViewController.h"

//tab页面
//#import "CRMainController.h"
//偏好设置
//#import "CRPreferencesController.h"
////关于
//#import "RCAboutUsController.h"
//角色选择
//#import "RoleSelectViewController.h"

@implementation AppDelegate

-(void) applicationDidFinishLaunching:(UIApplication *)application
{
    //register notification
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
    
    //配置首选项
    [self setupByPreferences];
    
    //Views Managment by Three20
    TTNavigator* navigator = [TTNavigator navigator];
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
    
    [map from:@"tt://approve_detail/(initWithName:)/(recordID:)/(screenName:)" 
       parent:@"tt://approve" 
toViewController:[HDApproveDetailViewController class] 
     selector:nil 
   transition:0];
    
    //main view
    //[map from:@"tt://main" toSharedViewController:[CRMainController class]];
    
    //    [map from:@"tt://preferences/(initWithStyle:)" 
    //       parent:@"aprove"  
    //toSharedViewController:[CRPreferencesController class]];
    
    //    [map from:@"tt://about" 
    //       parent:@"tt://preferences/1" 
    //toSharedViewController:[RCAboutUsController class]];
    
    
    //[map from:@"tt://menu/(initWithMenu:)" toSharedViewController:[MenuController class]];
    
    //角色选择
    //    [map from:@"tt://role_select" 
    //       parent:@"tt://login" 
    //toSharedViewController:[RoleSelectViewController class]];
    
    //    
    if(![navigator restoreViewControllers])
    {
        //        NSLog(@"No RestoreViewCtrl!!");
        [navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://approve"]];
        
        [navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://login"]applyTransition:UIViewAnimationTransitionFlipFromLeft]];
    }
    
}

- (void)setupByPreferences
{
    NSString *baseURL = [[NSUserDefaults standardUserDefaults] stringForKey:@"base_url_preference"];
	if (nil == baseURL)
	{
        //从root文件读取配置
        NSString *pathStr = [[NSBundle mainBundle] bundlePath];
		NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
		NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
        
		NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
		NSArray *prefSpecifierArray = [settingsDict objectForKey:@"PreferenceSpecifiers"];
        
		NSString *baseURLDefault = nil;
		NSString *approveDefault = nil;
		
		NSDictionary *prefItem;
		for (prefItem in prefSpecifierArray)
		{
			NSString *keyValueStr = [prefItem objectForKey:@"Key"];
			id defaultValue = [prefItem objectForKey:@"DefaultValue"];
			
			if ([keyValueStr isEqualToString:@"base_url_preference"])
			{
				baseURLDefault = defaultValue;
			}
			else if ([keyValueStr isEqualToString:@"default_approve_preference"])
			{
				approveDefault = defaultValue;
			}
			
		}
        	
		NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                     baseURLDefault, @"base_url_preference",
                                     approveDefault, @"default_approve_preference",
                                     nil];
        
		[[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
    
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //get the deivcetoken
    NSLog(@"My token is: %@", deviceToken);
    NSLog(@"%@",[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]); 
    //save deviceToken to userDefaults
    [[NSUserDefaults standardUserDefaults] setValue:[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] forKey:@"deviceToken"];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Error in registration.Error: %@" ,error);
    [[NSUserDefaults standardUserDefaults] setValue:@"null" forKey:@"deviceToken"];
}

#pragma -mark 程序进入后台或激活时触发事件，用于保存数据，处理程序重新进入后的初始化
-(void) applicationDidEnterBackground:(UIApplication *)application
{
    //    NSLog(@"%@",@"exit");
//        TTNavigator * nav = [TTNavigator navigator];
    
    //    if (![[nav visibleViewController] isKindOfClass:[RCLoginViewController class]]) {
    //        [nav openURLAction:[TTURLAction actionWithURLPath:@"tt://approve"]];
    //        [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"tt://login"]applyTransition:UIViewAnimationTransitionFlipFromLeft]];
    //    }
//    [[TTNavigator navigator].URLMap removeURL:@"tt://approve"];
    
//    [nav removeAllViewControllers];
}

//-(void) applicationDidBecomeActive:(UIApplication *)application
//{
//    TTNavigator * nav = [TTNavigator navigator];
    
//    if ([[nav visibleViewController] isKindOfClass:[ApproveListController class]]) {
//        [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:@"tt://approve"]];
//        [[nav visibleViewController] loadView];
//    }
//}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
