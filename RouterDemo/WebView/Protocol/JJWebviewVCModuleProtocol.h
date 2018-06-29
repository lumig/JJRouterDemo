//
//  JJWebviewVCModuleProtocol.h
//  WowTemplate
//
//  Created by luming on 2018/6/15.
//  Copyright © 2018年 luming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJProtocol.h"
#import "JJKit.h"
#import "FTBannerWebViewController.h"

JJ_EVENT_KEY(WebUrlString)
JJ_EVENT_KEY(Name)
JJ_EVENT_KEY(IsNoGoback)
@protocol JJWebviewVCModuleProtocol<JJBaseProtocol>

- (UIViewController *)viewControllerWithInfo:(id)userInfo needNew:(BOOL)needNew callback:(JJModuleCallbackBlock)callback;

@end


