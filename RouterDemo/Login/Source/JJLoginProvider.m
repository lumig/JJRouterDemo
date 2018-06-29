//
//  JJLoginProvider.m
//  MIGUDEMO
//
//  Created by luming on 2018/6/12.
//  Copyright © 2018年 luming. All rights reserved.
//

#import "JJLoginProvider.h"
#import "JJLoginProtocol.h"
#import "JJProtocolManager.h"
#import "JJLoginViewController.h"
@implementation JJLoginProvider

+ (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}



+ (void)load
{
    [JJProtocolManager registerModuleProvider:[self new] forProtocol:@protocol(JJLoginProtocol)];
}

- (void)showOnViewController:(UIViewController *)targetViewController success:(void (^)(id))successBlock fail:(void (^)(id))failBlock {

}

- (UIViewController *)viewControllerWithInfo:(id)userInfo needNew:(BOOL)needNew callback:(JJModuleCallbackBlock)callback
{
    JJLoginViewController *vc = [[JJLoginViewController alloc] init];
    return vc;
}

@end
