//
//  JJWebVCModuleProvider.m
//  WowTemplate
//
//  Created by luming on 2018/6/15.
//  Copyright © 2018年 luming. All rights reserved.
//

#import "JJWebVCModuleProvider.h"
#import "FTBannerWebViewController.h"
#import "JJWebviewVCModuleProtocol.h"
@implementation JJWebVCModuleProvider

+ (void)load
{
    [JJProtocolManager registerModuleProvider:[self new] forProtocol:@protocol(JJWebviewVCModuleProtocol)];
    

}

- (UIViewController *)viewControllerWithInfo:(id)userInfo needNew:(BOOL)needNew callback:(JJModuleCallbackBlock)callback{
    FTBannerWebViewController *vc = [[FTBannerWebViewController alloc] init];
    vc.urlStr = userInfo[WebUrlString];
    vc.name = userInfo[Name];
    vc.isNoGoback = userInfo[IsNoGoback];
    
    return vc;
}


@end
