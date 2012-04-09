//
//  ApproveTableAdapter.h
//  hrms
//
//  Created by mas apple on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Approve.h"
#import "ApproveListCell.h"

static const int SECTION_NORMAL = 0;
static const int SECTION_WAITING_LIST = 1;
static const int SECTION_PROBLEM_LIST = 2;

@interface ApproveTableAdapter : NSObject<UITableViewDataSource>{
    
    NSMutableArray *approveArray;
    NSMutableArray *commitArray;
    NSMutableArray *errorArray;
}

@property (retain,nonatomic) NSMutableArray *approveArray;
@property (retain,nonatomic) NSMutableArray *commitArray;
@property (retain,nonatomic) NSMutableArray *errorArray;

-(id)initWithApproveArray:(NSMutableArray *)aArray commitArray:(NSMutableArray *)cArray errorArray:(NSMutableArray *)eArray;

-(void)setApproveArray:(NSMutableArray *)aArray commitArray:(NSMutableArray *)cArray errorArray:(NSMutableArray *)eArray;
@end
