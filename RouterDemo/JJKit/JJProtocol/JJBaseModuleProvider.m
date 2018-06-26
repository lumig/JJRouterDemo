//
//  JJBaseModuleProvider.m
//  JJKit
//
//  Created by luming on 2018/6/5.
//  Copyright © 2018年 luming. All rights reserved.
//

#import "JJBaseModuleProvider.h"
#import "JJBaseProtocol.h"
#import "UIView+JJModule.h"
#import "UIViewController+JJModule.h"
#import "JJProtocolManager.h"
@interface JJBaseModuleProvider()<JJBaseProtocol>
@end
@implementation JJBaseModuleProvider

+ (void)load
{
    [JJProtocolManager registerModuleProvider:[self new] forProtocol:@protocol(JJBaseProtocol)];
}

- (UIView *)viewWithInfo:(id)userInfo needNew:(BOOL)needNew callback:(JJModuleCallbackBlock)callback
{
    //注意view变量必须在外部定义
    UIView *view;
    if (!self.view || needNew) {
        view = [UIView new];
        self.view = view;
    }
    self.view.jj_moduleUserInfo = userInfo;
    self.view.jj_moduleCallbackBlock = callback;
    return self.view;
}

- (UIViewController *)viewControllerWithInfo:(id)userInfo needNew:(BOOL)needNew callback:(JJModuleCallbackBlock)callback
{
    //注意vc变量必须在外部定义
    UIViewController *vc;
    if (!self.viewController || needNew) {
        vc = [UIViewController new];
        self.viewController = vc;
    }
    self.viewController.jj_moduleUserInfo = userInfo;
    self.viewController.jj_moduleCallbackBlock = callback;
    return self.viewController;
}

@end
