//
//  TTRoleSelectDataSource.h
//  hrms
//
//  Created by Rocky Lee on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
@interface HDRoleSelectModel : TTURLRequestModel

@property(nonatomic,readonly) NSArray * roleList;

@property(nonatomic,readonly) BOOL isLoadedRole;
@property(nonatomic,readonly) BOOL isSelectedRole;

@end

@interface HDRoleSelectDataSource : TTListDataSource

@property(nonatomic,readonly) HDRoleSelectModel * roleSelectModel;

@end
