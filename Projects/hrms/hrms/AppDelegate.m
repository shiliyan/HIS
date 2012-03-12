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
//tab页面
//#import "CRMainController.h"
//偏好设置
//#import "CRPreferencesController.h"
////关于
//#import "RCAboutUsController.h"
//审批
#import "ApproveListController.h"

@implementation AppDelegate

-(void) applicationDidFinishLaunching:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
    //register notification
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
    
    
    //Views Managment by Three20
    TTNavigator* navigator = [TTNavigator navigator];
    navigator.persistenceMode = TTNavigatorPersistenceModeAll;
    
    navigator.window = [[[UIWindow alloc] initWithFrame:TTScreenBounds()] autorelease];
    [TTStyleSheet setGlobalStyleSheet:[[[MyStyleSheet alloc]init]autorelease]];
    
    TTURLMap* map = navigator.URLMap;
    
    // Any URL that doesn't match will fall back on this one, and open in the web browser
    [map from:@"*" toViewController:[TTWebController class]];
    
    //login view
    [map from:@"tt://login" toModalViewController:[RCLoginViewController class]];
    
    //main view
    //[map from:@"tt://main" toSharedViewController:[CRMainController class]];
    
//    [map from:@"tt://preferences/(initWithStyle:)" 
//       parent:@"aprove"  
//toSharedViewController:[CRPreferencesController class]];
    
//    [map from:@"tt://about" 
//       parent:@"tt://preferences/1" 
//toSharedViewController:[RCAboutUsController class]];
    
    //审批
    [map from:@"tt://aprove" 
       parent:@"tt://preferences/1" 
toSharedViewController:[ApproveListController class]];
    //[map from:@"tt://menu/(initWithMenu:)" toSharedViewController:[MenuController class]];
    
    
    
    if (![navigator restoreViewControllers]) {
        [navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://login"]];
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
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"注册推送失败，检查网络或推送服务" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
//    [alert show];
//    [alert release];
    
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"deviceToken"];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
