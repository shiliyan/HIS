//
//  ApproveListDetailController.h
//  Approve
//
//  Created by mas apple on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Approve.h"

@interface ApproveListDetailController : UIViewController{
    UILabel *label;
    Approve *data;
}

@property (retain, nonatomic) IBOutlet UILabel *label;
@property (retain, nonatomic) Approve *data;

@end
