//
//  HECLoginViewController.h
//  hrms
//
//  Created by Rocky Lee on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RCLoginViewController.h"

@interface HECLoginViewController : RCLoginViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) UITableView * roleSelectView;
@property (nonatomic,retain) NSArray * roleList;

@end
