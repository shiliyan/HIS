//
//  AccountSettingsController.m
//  hrms
//
//  Created by mas apple on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDAccountSettingsController.h"
#import "HDHTTPRequestCenter.h"
#import "HDURLCenter.h"


@interface HDAccountSettingsController ()

@end

@implementation HDAccountSettingsController

-(void)exitApplication:(id)sender{
    
    HDFormDataRequest *request = [[HDHTTPRequestCenter shareHTTPRequestCenter]requestWithURL:[HDURLCenter requestURLWithKey:@"LOGOUT_SYSTEM_PATH"] requestType:HDRequestTypeFormData forKey:nil];
    [request setDelegate:self];
    [request setSuccessSelector:@selector(quitSuccess:dataSet:)];
    [request setFailedSelector:@selector(quitFailure:error:)];
    [request setErrorSelector:@selector(quitFailure:error:)];
    [request setServerErrorSelector:@selector(quitFailure:error:)];  
    
    [request startAsynchronous];
}

-(void)quitSuccess:(ASIFormDataRequest *) request dataSet:(NSArray *)dataSet{
    CALayer *animationLayer = self.view.window.layer;
    
    //动画处理
    [UIView animateWithDuration:0.3 animations:^{
        
        animationLayer.affineTransform =CGAffineTransformMakeScale(1, 0.005);
        animationLayer.backgroundColor = [[UIColor whiteColor]CGColor];
        } 
                     completion:^(BOOL isFinished){
            if (isFinished) {
                [UIView animateWithDuration:0.2 animations:^{
                    animationLayer.affineTransform = CGAffineTransformScale(animationLayer.affineTransform, 0.001, 1);
                } completion:^(BOOL isAllFinished){
                    if (isAllFinished) {
                        [self clearDatas];
                        exit(0); 
                    }
                }];
            }
        }];
    
}

-(void)quitFailure:(ASIFormDataRequest *) request error:(NSDictionary *) errorObject{
    TTAlertNoTitle(@"退出系统失败，请在稍后有网络连接的条件下重试。");
}

-(void)clearDatas{
    //删除保存账户名密码
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"username"];
    [defaults removeObjectForKey:@"password"];
    [defaults synchronize];
    
    
    //删除本地数据库
    BOOL success;
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
    NSString *documentDirectory = [paths objectAtIndex:0];  
    //dbPath： 数据库路径，在Document中。  
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DB_NAME];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // delete the old db.
    if ([fileManager fileExistsAtPath:dbPath]){
        success = [fileManager removeItemAtPath:dbPath error:&error];
        if (!success) {
            NSAssert1(0, @"Failed to delete old database file with message '%@'.", [error localizedDescription]);
        }
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
    
}

-(CAAnimation *)animationVerticalScale{
    CGAffineTransform verticalScale = CGAffineTransformMakeScale(1, 0.01);
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.toValue = [NSValue valueWithCGAffineTransform:verticalScale];
    animation.duration = 0.5;
    animation.repeatCount=1;
    animation.beginTime = 0.2;
    animation.delegate = self;
    animation.removedOnCompletion = NO;
    
    return animation;
}

-(CAAnimation *)animationHorizontalScale:(CGAffineTransform)previousTransform{
    CGAffineTransform horizontalScale = CGAffineTransformScale(previousTransform, 0.01, 1);
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.toValue = [NSValue valueWithCGAffineTransform:horizontalScale];
    animation.duration = 0.5;
    animation.repeatCount=1;
    animation.beginTime = 0.3;
    animation.delegate = self;
    animation.removedOnCompletion = NO;
    
    return animation;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.image = [UIImage imageNamed:@"preferences.png"];
        self.tabBarItem.title = @"账户设置";
        self.title = @"账户设置";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
