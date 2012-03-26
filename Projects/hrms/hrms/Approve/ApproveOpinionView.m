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
@synthesize okButton;
@synthesize cancelButton;

-(void)viewDidLoad{
    [super viewDidLoad];

}

-(void)viewDidAppear:(BOOL)animated{
    
    opinionTextView.text = @"";
    [super viewDidAppear:animated];
}

-(void)viewDidUnload{
    [super viewDidUnload];
    titleLabel = nil;
    opinionTextView = nil;
    okButton = nil;
    cancelButton = nil;
}

-(void)dealloc{
    [super dealloc];
    [titleLabel release];
    [opinionTextView release];
    [okButton release];
    [cancelButton release];
}

-(IBAction)commitData:(id)sender{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
    [dic setObject:[NSNumber numberWithInt:approveType] forKey:@"type"];
    [dic setObject:opinionTextView.text forKey:@"comment"];
    [controllerDelegate ApproveOpinionViewDismissed:RESULT_OK messageDictionary:dic];
    
}
-(IBAction)cancelCommit:(id)sender{
    [controllerDelegate ApproveOpinionViewDismissed:RESULT_CANCEL messageDictionary:nil];
}

-(IBAction)toggleOutKeybord:(id)sender{
    [opinionTextView resignFirstResponder];
}

-(void)setControllerDelegate:(id<ApproveOpinionViewDelegate>)inDelegate{
    controllerDelegate = inDelegate;
}
@end
