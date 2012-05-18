//
//  ApproveTableAdapter.m
//  hrms
//
//  Created by mas apple on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ApproveTableAdapter.h"

@implementation ApproveTableAdapter

@synthesize approveArray;

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellTableIdentifier = @"ApproveCellIdentifier";
    ApproveListCell *cell= nil;
    
    NSUInteger row = [indexPath row];
    Approve *rowData = [approveArray objectAtIndex:row];
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    
    if (cell == nil){
        cell = [[ApproveListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTableIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [cell setCellData:rowData];
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSUInteger count = [self.approveArray count];
    return count;
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    Approve *entity = [self.approveArray objectAtIndex:row];
    if ([entity.localStatus isEqualToString:@"NORMAL"] || [entity.localStatus isEqualToString:@"ERROR"]) {
        return true;
    }else{
        return false;
    }
    
}

-(id)init{
    self = [super init];
    if (self){
        self.approveArray = [NSMutableArray array];
    }
    return self;
}

-(id)initWithApproveArray:(NSMutableArray *)aArray{
    self = [self init];
    if(self){
        self.approveArray = aArray;
    }
    return  self;
}
@end
