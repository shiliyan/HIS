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

@interface ApproveTableAdapter : NSObject<UITableViewDataSource>{
    
    NSMutableArray *approveArray;
}

@property (retain,nonatomic) NSMutableArray *approveArray;

-(id)initWithApproveArray:(NSMutableArray *)aArray;
@end
