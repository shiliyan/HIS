//
//  HDConfigLoader.m
//  Three20Lab
//
//  Created by Rocky Lee on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDClassLoader.h"

static NSString * kClassName = @"name";
static NSString * kNavigationMode = @"navigation_mode";
static NSString * kURL = @"url";
static NSString * kParent = @"parent";

static NSString * kShare = @"share";
static NSString * kCreate = @"create";
static NSString * kModal = @"modal";

@implementation HDClassLoader

-(void)startLoadClass
{
    TTDPRINT(@"start loading");
    //获取classes节点,用于加载类的配置
    HDClassConfigParser * classConfigParser = [[HDClassConfigParser alloc]init];
    [[HDNavigator navigator].URLMap from:@"*" toViewController:[TTWebController class]];
    [classConfigParser setDelegate:self];
    [classConfigParser startParse];
    [classConfigParser release];
}

#pragma -mark delegate functions of class parser
-(void)setNibLoadPathWithElement:(CXMLElement *)element
{   
    HDNavigator * _navigator = [HDNavigator navigator];
    if (!_navigator) {
        return;
    }
    NSString * urlPath = [[element attributeForName:kURL]stringValue];
    NSString * mode = [[element attributeForName:kNavigationMode]stringValue];
    if ([mode isEqualToString:kShare]) {
        [_navigator.URLMap from:urlPath toSharedViewController:_navigator];
    }
    if ([mode isEqualToString:kModal]) {
        [_navigator.URLMap from:urlPath toModalViewController:_navigator];
        
    }
}   

-(void)setClassLoadPathWithElement:(CXMLElement *)element
{
    HDNavigator * _navigator = [HDNavigator navigator];
    if (!_navigator) {
        return;
    }
    NSString * urlPath = [[element attributeForName:kURL]stringValue];
    NSString * mode = [[element attributeForName:kNavigationMode]stringValue];
    NSString * parentPath =[[element attributeForName:kParent]stringValue];
    NSString * className = [[element attributeForName:kClassName]stringValue];
    
    if (!parentPath) {
        [self setClassLoadPath:urlPath 
                     className:className
                          mode:mode];
        
    }else {
        [self setClassLoadPath:urlPath 
                        parent:parentPath
                     className:className
                          mode:mode];
    }
}

-(void)setClassLoadPath:(NSString *) urlPath
                 parent:(NSString *) parentPath
              className:(NSString *)className
                   mode:(NSString *)mode
{
    HDNavigator * _navigator = [HDNavigator navigator];
    if ([mode isEqualToString:kShare]) {
        [_navigator.URLMap from:urlPath
                         parent:parentPath 
         toSharedViewController:NSClassFromString(className)];
    }
    if ([mode isEqualToString:kModal]) {
        [_navigator.URLMap from:urlPath 
                         parent:parentPath 
          toModalViewController:NSClassFromString(className) 
                       selector:nil 
                     transition:0];
    }
    if ([mode isEqualToString:kCreate]) {
        [_navigator.URLMap from:urlPath parent:parentPath
               toViewController:NSClassFromString(className)
                       selector:nil
                     transition:0];
    }
}

-(void)setClassLoadPath:(NSString *) urlPath 
              className:(NSString *)className
                   mode:(NSString *)mode
{
    HDNavigator * _navigator = [HDNavigator navigator];
    if ([mode isEqualToString:kShare]) {
        [_navigator.URLMap from:urlPath 
         toSharedViewController:NSClassFromString(className)];
    }
    if ([mode isEqualToString:kModal]) {
        [_navigator.URLMap from:urlPath 
          toModalViewController:NSClassFromString(className)];
    }
    if ([mode isEqualToString:kCreate]) {
        [_navigator.URLMap from:urlPath 
               toViewController:NSClassFromString(className)];
    }
}


@end
