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
@synthesize commitArray;
@synthesize errorArray;

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellTableIdentifier = @"ApproveCellIdentifier";
    ApproveListCell *cell= nil;
    
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    Approve *rowData = nil;
    
    if (section == SECTION_NORMAL) {
        rowData = [approveArray objectAtIndex:row];
    }else if(section == SECTION_WAITING_LIST){
        rowData = [commitArray objectAtIndex:row];
    }else if(section == SECTION_PROBLEM_LIST){
        rowData = [errorArray objectAtIndex:row];
    }
    
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    
    if (cell == nil){
        cell = [[ApproveListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTableIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [cell setCellData:rowData];
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == SECTION_NORMAL) {
        NSUInteger count = [self.approveArray count];
        return count;
    }else if(section == SECTION_WAITING_LIST){
        return [self.commitArray count];
    }else if (section == SECTION_PROBLEM_LIST){
        NSUInteger count = [self.errorArray count];
        return count;
    }else{
        return 0;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == SECTION_NORMAL) {
        return [self.approveArray count]==0 ? @"" : @"待办";
    }else if(section == SECTION_WAITING_LIST){
        return [self.commitArray count]==0 ? @"" : @"等待提交";
    }else if(section == SECTION_PROBLEM_LIST){
        return [self.errorArray count]==0 ? @"" : @"出错的审批或已在别处处理";
    }else{
        return nil;
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger section = [indexPath section];
    if (section == SECTION_NORMAL) {
        return true;
    }else{
        return false;
    }
}

-(void)setApproveArray:(NSMutableArray *)aArray commitArray:(NSMutableArray *)cArray errorArray:(NSMutableArray *)eArray{
    self.approveArray = aArray;
    self.commitArray = cArray;
    self.errorArray = eArray;
}

-(id)init{
    self = [super init];
    if (self){
        self.approveArray = [NSMutableArray array];
        self.commitArray = [NSMutableArray array];
        self.errorArray = [NSMutableArray array];
    }
    return self;
}

-(id)initWithApproveArray:(NSMutableArray *)aArray commitArray:(NSMutableArray *)cArray errorArray:(NSMutableArray *)eArray{
    self = [self init];
    if(self){
        self.approveArray = aArray;
        self.commitArray = cArray;
        self.errorArray = eArray;
    }
    return  self;
}
@end
