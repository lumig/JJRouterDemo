//
//  JJActionService.m
//
//  Created by luming on 2018/6/7.
//  Copyright © 2018年 luming. All rights reserved.
//
#import "JJRouter.h"

#import "Action.h"
#import "JJActionJumpMacro.h"
#import "JJActionService.h"
#import <YYKit.h>
#import "JJLoginProtocol.h"
#import "JJLoginProvider.h"
#import "JJKit.h"
#import "NSObject+CurrentNav.h"
#import "JJWebviewVCModuleProtocol.h"
#import "JJWebVCModuleProvider.h"
@implementation JJActionService

//登录
JJROUTER_EXTERN_METHOD(JJActionService, jjLogin, arg, callback){
//    NSDictionary *obj = arg[Jump_Key_Param];
    id<JJLoginProtocol> provider = [JJProtocolManager moduleProviderForProtocol:@protocol(JJLoginProtocol)];
    UIViewController *vc =[provider viewControllerWithInfo:nil needNew:YES callback:^(id info) {
        if (callback) {
            callback(info);
        }
    }];
    NSLog(@"========= currentNav ====== %@========vc ===%@",self.currentNav,vc);
    vc.hidesBottomBarWhenPushed = YES;

    [self.currentNav pushViewController:vc animated:YES];
    
    return nil;
}


//跳转webview
JJROUTER_EXTERN_METHOD(JJActionService, showWebVC, arg, callback){
    NSDictionary *obj =arg[Jump_Key_Param];
    id<JJWebviewVCModuleProtocol> provider = [JJProtocolManager moduleProviderForProtocol:@protocol(JJWebviewVCModuleProtocol)];
    UIViewController *vc =[provider viewControllerWithInfo:obj needNew:YES callback:^(id info) {
        if (callback) {
            callback(info);
        }
    }];
    vc.hidesBottomBarWhenPushed = YES;
    [self.currentNav pushViewController:vc animated:YES];
    
    return nil;
}




@end
