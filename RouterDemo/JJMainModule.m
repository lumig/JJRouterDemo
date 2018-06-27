//
//  JJMainModule.m
//  MIGUDEMO
//
//  Created by luming on 2018/6/7.
//  Copyright © 2018年 luming. All rights reserved.
//

#import "JJMainModule.h"
#import "JJRouter.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "JJLoginProtocol.h"
#import "JJLoginProvider.h"
#import "ViewController.h"
@implementation JJMainModule
//注册每个模块需要调用appdelegate的生命周期方法
+ (void)load
{
    NSArray *array = @[
                       @"JJMainModule",
//                       @"JJLoginProvider"

                       ];
    NSDictionary *config = @{
                             @"router://JJAppDelegateModule/setDidFinishLaunchingModules" : array,
                             @"router://JJAppDelegateModule/setApplicationOpenURLOptionsModules" : array,
                             @"router://JJAppDelegateModule/setOpenURLModules" : array,
                             @"router://JJAppDelegateModule/setApplicationDidEnterBackgroundModules" : array,
                             @"router://JJAppDelegateModule/setApplicationWillEnterForegroundModules" : array,
                             @"router://JJAppDelegateModule/setApplicationDidBecomeActiveModules" : array,
                             @"router://JJAppDelegateModule/setApplicationWillTerminateModules" : array,
                             @"router://JJAppDelegateModule/setSupportedInterfaceOrientationsForWindow" : array,
                             @"router://JJAppDelegateModule/setDidReceiveRemoteNotificationModules" : array,
                             @"router://JJAppDelegateModule/setDidRegisterForRemoteNotificationsWithDeviceTokenModules" : array,
                             @"router://JJAppDelegateModule/setUserNotificationCenterDidReceiveNotificationResponseModules" : array,
                             @"router://JJAppDelegateModule/setContinueUserActivityModules" : array,
                             @"router://JJAppDelegateModule/setApplicationHandleOpenURLModules" : array
                             };
    for (NSString *url in config)
    {
        [JJRouter openURL:url arg:config[url] error:nil completion:nil];
    }

    NSString *urlrun = @"router://JJAppDelegateModule/run";
    [JJRouter openURL:urlrun arg:nil error:nil completion:nil];
}

//调用该模块appdelegate需要执行生命周期方法
+ (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    

    gWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    gWindow.backgroundColor = [UIColor whiteColor];
    gWindow.hidden = NO;
    [gWindow makeKeyAndVisible];
    ViewController *vc =[[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    gWindow.rootViewController = nav;
    
    [gWindow makeKeyAndVisible];
    [[UIButton appearance] setExclusiveTouch:YES];


    
    return YES;
}

+ (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    
    [JJRouter openURL:url.absoluteString arg:nil error:nil completion:nil];
    return YES;
}

+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return YES;
}

+ (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
@end
