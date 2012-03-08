//
//  TreeModel.m
//  LoginDemo
//
//  Created by Stone Lee on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TreeModel.h"

@implementation TreeModel

-(id)initWithMenuData:(NSMutableArray *)menuData
{
    self = [super init];
    if(self)
    {
        self.tree = menuData;
        self.rootNode = [[NSMutableDictionary alloc]initWithDictionary:[menuData objectAtIndex:0]];
        [self.rootNode setValue:[NSNumber numberWithInt:-1] forKey:@"function_id"];
        [self.rootNode setValue:@"Menu" forKey:@"function_name"];
    }
    return self;
}
- (id)init
{
    self = [super init];    
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    [self.tree release];
    [self.rootNode release];
    [super dealloc];
}

//get current table of current node
-(NSArray *)tableForNode:(NSDictionary *)targetNode{
    NSMutableArray * table = [[[NSMutableArray alloc]init]autorelease];
    for (NSDictionary * node in self.tree) {   
        if ([[node valueForKey:@"parent_function_id"] isEqual:[targetNode valueForKey:@"function_id"]] || ([node valueForKey:@"parent_function_id"]==[targetNode valueForKey:@"function_id"])) {
            [table addObject:node];
        }
    }
    return table;
}

//opinion whether the node has children
-(BOOL) isLeafNode:(NSDictionary *) targetNode
{
    NSString * functionId = [targetNode valueForKey:@"function_id"];
    for (NSDictionary * node in self.tree) {
        if ([[node valueForKey:@"parent_function_id"]isEqual:functionId]) {
            return NO;
        }
    }
    return YES;
}

@synthesize tree;
@synthesize rootNode;

@end
