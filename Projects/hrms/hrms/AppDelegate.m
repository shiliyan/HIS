//
//  AppDelegate.m
//  hrms
//
//  Created by Rocky Lee on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

//styleSheet
#import "MyStyleSheet.h"
//view controllers
#import "RCLoginViewController.h"
//tab页面
#import "CRMainController.h"
//偏好设置
#import "CRPreferencesController.h"
//关于
#import "RCAboutUsController.h"
//审批
#import "ApproveListController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
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
    [map from:@"tt://main" toSharedViewController:[CRMainController class]];
    
    [map from:@"tt://preferences/(initWithStyle:)"  toSharedViewController:[CRPreferencesController class]];
    
    [map from:@"tt://about" toSharedViewController:[RCAboutUsController class]];
    
    //审批
    [map from:@"tt://aprove" parent:@"aprove" toSharedViewController:[ApproveListController class]];
//    [map from:@"tt://menu/(initWithMenu:)" toSharedViewController:[MenuController class]];
    
    
    
    if (![navigator restoreViewControllers]) {
        [navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://login"]];
    }
    return YES;
//
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil] autorelease];
//    } else {
//        self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil] autorelease];
//    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
