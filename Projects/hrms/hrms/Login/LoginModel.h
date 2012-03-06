//
//  LoginModel.h
//  HRMS
//
//  Created by Rocky Lee on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginModel : NSObject{

}

@property (nonatomic,retain) NSString * username;
@property (nonatomic,retain) NSString * password;
@property (nonatomic,retain) NSString * languageDisplay;
@property (nonatomic,retain) NSString * languageValue;

-(id) toDataSet;
@end
