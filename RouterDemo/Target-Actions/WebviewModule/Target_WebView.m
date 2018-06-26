//
//  Target_WebView.m
//  RouterDemo
//
//  Created by luming on 2018/6/26.
//  Copyright © 2018年 luming. All rights reserved.
//

#import "Target_WebView.h"
#import "FTBannerWebViewController.h"
@implementation Target_WebView

-(UIViewController *)Action_showWebViewController:(NSDictionary *)params
{
    FTBannerWebViewController *vc = [[FTBannerWebViewController alloc] init];
    vc.urlStr = params[@"urlStr"];
    vc.name = params[@"name"];
    vc.isNoGoback = params[@"isNoGoback"];
    return vc;
}

@end
