//
//  ApproveOpinionView.m
//  Approve
//
//  Created by mas apple on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ApproveOpinionView.h"

@implementation ApproveOpinionView

-(void)viewDidLoad{
    
    UIControl *contentView = [[[UIControl alloc]initWithFrame:CGRectMake(0, 0, 320, 480)]autorelease];
    [contentView addTarget:self action:@selector(toggleOutKeybord:) forControlEvents:UIControlEventTouchUpInside];
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.view = contentView;
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 82, 85, 21)];
    titleLabel.text = @"处理意见";
    [self.view addSubview:titleLabel];
    
    opinionTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, 111, 280, 176)];
    opinionTextView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview: opinionTextView];
    
    okButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    okButton.frame = CGRectMake(20, 330, 72, 37);
    [okButton setTitle:@"提交" forState:UIControlStateNormal ];
    [okButton addTarget:self action:@selector(commitData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okButton];
    
    cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.frame = CGRectMake(228 , 330, 72, 37);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal ];
    [cancelButton addTarget:self action:@selector(cancelCommit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
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

-(void)commitData{
    [controllerDelegate ApproveOpinionViewDismissed:RESULT_OK messageObject:nil];
    
}
-(void)cancelCommit{
    [controllerDelegate ApproveOpinionViewDismissed:RESULT_CANCEL messageObject:nil];
}

-(void)toggleOutKeybord:(id)sender{
    [opinionTextView resignFirstResponder];
}

-(void)setControllerDelegate:(id<ApproveOpinionViewDelegate>)inDelegate{
    controllerDelegate = inDelegate;
}
@end
