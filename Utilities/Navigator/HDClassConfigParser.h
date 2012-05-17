//
//  HDClassParser.h
//  Three20Lab
//
//  Created by Rocky Lee on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@protocol HDClassConfigParserDelegate; 

@interface HDClassConfigParser : NSObject

@property(nonatomic,assign) id <HDClassConfigParserDelegate> delegate;

-(void)startParse;

@end

@protocol HDClassConfigParserDelegate <NSObject>
@required

//加载初始化节点
-(void)setNibLoadPathWithElement:(CXMLElement *) element;

-(void)setClassLoadPathWithElement:(CXMLElement *) element;

@end
