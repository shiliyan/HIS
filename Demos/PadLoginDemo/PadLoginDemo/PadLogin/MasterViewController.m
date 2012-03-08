//
//  MasterViewController.m
//  LoginDemo
//
//  Created by Stone Lee on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "UIViewController+HttpRequestHelper.h"

@interface MasterViewController()
-(void)subMenuSelctComplete:(ASIHTTPRequest *)theRequest;;
@end

@implementation MasterViewController

@synthesize detailViewController;
@synthesize menu;

-(void)subMenuSelctComplete:(id) dataSet
{  
    NSMutableArray * menuData = dataSet;
        if (menuData.count > 0) {
            MasterViewController * masterViewCtrl = [[[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil] autorelease];
            
            masterViewCtrl.detailViewController = self.detailViewController;            
            masterViewCtrl.menu = menuData;
            masterViewCtrl.title = [selectedNode valueForKey:@"function_name"];
            
            [self.navigationController pushViewController:masterViewCtrl animated:YES];
        }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    return self;
}

- (void)dealloc
{
    [self.detailViewController release];
    [self.menu release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
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
    return self.menu.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell.
    NSDictionary * node = [self.menu objectAtIndex:indexPath.row];
    
    //set lable text
    cell.textLabel.text = NSLocalizedString([node valueForKey:@"function_name"], @"Detail");
    
    //set style
    if([[[self.menu objectAtIndex:indexPath.row] objectForKey:@"function_type" ]isEqual:@"G"])
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
    //    if (!self.detailViewController) {
    //        self.detailViewController = [[[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil] autorelease];
    //    }
    //customer
    //-----------------------------new---------------
    selectedNode = [self.menu objectAtIndex:indexPath.row];
    
    if ([[selectedNode valueForKey:@"function_type"]isEqual:@"F"]) {
        NSString * urlStr = [NSString stringWithFormat:@"http://localhost:8080/hrms/%@", [selectedNode valueForKey:@"command_line"]];
        self.detailViewController.url = [NSURL URLWithString:urlStr];
        [self.detailViewController refreshWebView];
        //if orient is vertical hide masterPopoverController
        [self.detailViewController dismissMasterPopover];
    }else{
        [self formRequest:@"http://localhost:8080/hrms/autocrud/demo.demo_menu_query/query"
                 withData:selectedNode 
          successSelector:@selector(subMenuSelctComplete:) 
           failedSelector:nil 
            errorSelector:nil];
    }
}

@end
