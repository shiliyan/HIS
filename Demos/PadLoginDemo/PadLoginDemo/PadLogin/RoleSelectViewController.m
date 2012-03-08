//
//  RoleSelectViewController.m
//  LoginDemo
//
//  Created by Stone Lee on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RoleSelectViewController.h"
#import "UIViewController+HttpRequestHelper.h"
#import "MasterViewController.h"
#import "DetailViewController.h"

#define COOKBOOK_PURPLE_COLOR [UIColor colorWithRed:0.0f green:0.2845f blue:0.55556f alpha:1.0f]

@interface RoleSelectViewController()
- (void)getMainMenuSecretFetchComplete:(ASIHTTPRequest *)theRequest;
- (void)roleSelctComplete:(ASIHTTPRequest *) theRequest;
@end

@implementation RoleSelectViewController

#pragma mark http request functions

- (void)getMainMenuSecretFetchComplete:(id)dataSet
{
    //set detail view
    DetailViewController * detailViewController = [[[DetailViewController alloc] initWithNibName:@"DetailViewController"bundle:nil] autorelease];
    detailViewController.url = [NSURL URLWithString:@"http://172.20.0.38/"];
    
    UINavigationController * detailNavigationController = [[[UINavigationController alloc] initWithRootViewController:detailViewController] autorelease];
    
    detailNavigationController.navigationBar.tintColor = COOKBOOK_PURPLE_COLOR;
    //---------------------------------------------------------------------
    
    //set master view
    MasterViewController *masterViewController = [[[MasterViewController alloc] initWithNibName:@"MasterViewController"bundle:nil] autorelease];
    
    masterViewController.menu = dataSet;
    masterViewController.title = @"Menu";
    masterViewController.detailViewController = detailViewController;
    
    UINavigationController *masterNavigationController = [[[UINavigationController alloc] initWithRootViewController:masterViewController] autorelease];
    
    masterNavigationController.navigationBar.tintColor =COOKBOOK_PURPLE_COLOR;
    //---------------------------------------------------------------------
    
    //set split view
    self.splitViewController = [[[UISplitViewController alloc] init] autorelease];
    self.splitViewController.delegate = detailViewController;
    self.splitViewController.viewControllers = [NSArray arrayWithObjects:masterNavigationController, detailNavigationController, nil];    
    //---------------------------------------------------------------------
    
    //animation,change view to split view
    [UIView beginAnimations:@"animation"context:nil];    
    [UIView setAnimationDuration:0.6f];
    self.view.window.rootViewController = self.splitViewController;
    [UIView commitAnimations];
    
}

-(void)roleSelctComplete:(id) dataSet{
    NSDictionary * rootNode = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:-1],@"function_id",nil ];
    
    [self formRequest: @"http://localhost:8080/hrms/autocrud/demo.demo_menu_query/query" 
             withData:rootNode 
      successSelector:@selector(getMainMenuSecretFetchComplete:)  
       failedSelector:nil 
        errorSelector:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    //    [self.roleSelectView release];
    //    [self.formRequest release];
    [self.splitViewController release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.roleMenu.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if (self.roleMenu) {
        cell.textLabel.text = [[self.roleMenu objectAtIndex:indexPath.row]valueForKey:@"role_description"];
    }
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self formRequest:@"http://localhost:8080/hrms/role_select.svc"
             withData:[self.roleMenu objectAtIndex:indexPath.row]  
      successSelector:@selector(roleSelctComplete:)  
       failedSelector:nil 
        errorSelector:nil];
}


//@synthesize roleSelectView;
@synthesize splitViewController;

@synthesize roleMenu;

@end

