//
//  ApproveOpinionView.m
//  Approve
//
//  Created by mas apple on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ApproveOpinionView.h"

@implementation ApproveOpinionView

@synthesize approveType;

@synthesize titleLabel;
@synthesize opinionTextView;

-(void)viewDidLoad{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    opinionTextView.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"default_approve_preference"];
    [opinionTextView becomeFirstResponder];
}

-(void)viewDidUnload{
    [super viewDidUnload];
    titleLabel = nil;
    opinionTextView = nil;
}

-(void)dealloc{
    [super dealloc];
    [titleLabel release];
    [opinionTextView release];
}

-(IBAction)commitData:(id)sender{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
    [dic setObject:(approveType == nil ? @"" : approveType) forKey:@"type"];
    [dic setObject:opinionTextView.text forKey:@"comment"];
    [controllerDelegate ApproveOpinionViewDismissed:RESULT_OK messageDictionary:dic];
    
}
-(IBAction)cancelCommit:(id)sender{
    [controllerDelegate ApproveOpinionViewDismissed:RESULT_CANCEL messageDictionary:nil];
}

-(void)setControllerDelegate:(id<ApproveOpinionViewDelegate>)inDelegate{
    controllerDelegate = inDelegate;
}
@end
