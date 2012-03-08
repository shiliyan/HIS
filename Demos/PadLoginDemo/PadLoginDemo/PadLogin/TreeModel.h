//
//  TreeModel.h
//  LoginDemo
//
//  Created by Stone Lee on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreeModel : NSObject
{
    NSMutableArray * tree;
    NSDictionary * rootNode;
}

@property (nonatomic,retain) NSDictionary * rootNode;
@property (nonatomic,retain) NSMutableArray * tree;

-(id)initWithMenuData:(NSMutableArray *)menuData;

//get current table of current node
-(NSArray *)tableForNode:(NSDictionary *)targetNode; 

//opinion whether the node has children
-(BOOL) isLeafNode:(NSDictionary *) targetNode;

@end
