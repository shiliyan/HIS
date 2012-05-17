//
//  HDNavigator.m
//  Three20Lab
//
//  Created by Rocky Lee on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDNavigator.h"
#import "HDClassLoader.h"

@implementation HDNavigator
//@synthesize configLoader = _configLoader;
//@synthesize objectDictionary = _objectDictionary;
//@synthesize sysConfig = _sysConfig;

+(HDNavigator *)navigator
{
    TTBaseNavigator* navigator = [TTBaseNavigator globalNavigator];
    if (nil == navigator) {
        navigator = [[[HDNavigator alloc] init] autorelease];
        // setNavigator: retains.
        [super setGlobalNavigator:navigator];
        //加载类
        HDClassLoader * classLoader = [[HDClassLoader alloc]init];
        [classLoader startLoadClass];
        TT_RELEASE_SAFELY(classLoader);
    }
    // If this asserts, it's likely that you're attempting to use two different navigator
    // implementations simultaneously. Be consistent!
    TTDASSERT([navigator isKindOfClass:[HDNavigator class]]);
    return (HDNavigator*)navigator;
    
}

-(void)dealloc
{
    [super dealloc];
}

#pragma -mark 从nib加载
///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)setLoadFromNib
{
    [_URLMap from:@"init://shareNib/(loadFromNib:)" toSharedViewController:self];
    [_URLMap from:@"init://shareNib/(loadFromNib:)/(withClass:)" toSharedViewController:self];
    [_URLMap from:@"init://modalNib/(loadFromNib:)" toModalViewController:self];
    [_URLMap from:@"init://modalNib/(loadFromNib:)/(withClass:)"  toModalViewController:self];
}

#pragma -mark load from nib
/**
 * Loads the given viewcontroller from the nib
 */
- (UIViewController*)loadFromNib:(NSString *)nibName withClass:className {
    UIViewController* newController = [[NSClassFromString(className) alloc]
                                       initWithNibName:nibName bundle:nil];
    [newController autorelease];
    
    return newController;
}
/**
 * Loads the given viewcontroller from the the nib with the same name as the
 * class
 */
- (UIViewController*)loadFromNib:(NSString*)className {
    return [self loadFromNib:className withClass:className];
}

#pragma -mark create object from urlaction,navigator did not retain the object.
-(id)createObjectWithURLAction:(TTURLAction*)action
{
    if (nil == action || nil == action.urlPath) {
        return nil;
    }
    // We may need to modify the urlPath, so let's create a local copy.
    NSString* urlPath = action.urlPath;
    TTURLNavigatorPattern* pattern = nil;
    //创建对象
    id object = [_URLMap objectForURL:urlPath query:action.query pattern:(TTURLNavigatorPattern**)pattern];
    //添加对象到map中管理
    //    [_objectDictionary setValue:object forKey:action.urlPath];
    return object;
}

-(void)removeObjectWithURL:(NSString *)urlPath
{
    //    [_objectDictionary removeObjectForKey:urlPath];
    [self.URLMap removeObjectForURL:urlPath];
}
@end
