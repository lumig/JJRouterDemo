//
//  CTMediator+ModuleLogin.m
//  RouterDemo
//
//  Created by luming on 2018/6/26.
//  Copyright © 2018年 luming. All rights reserved.
//

#import "CTMediator+ModuleLogin.h"
NSString * const kCTMediatorTargetA = @"A";
NSString * const kCTMediatorActionLoginViewController = @"showLoginController";

@implementation CTMediator (ModuleLogin)

- (UIViewController *)push_viewControllerForLogin
{
    UIViewController *vc = [self performTarget:kCTMediatorTargetA action:kCTMediatorActionLoginViewController params:nil shouldCacheTarget:NO];
    
    if ([vc isKindOfClass:[UIViewController class]]) {
        // view controller 交付出去之后，可以由外界选择是push还是present
        return vc;
    } else {
        // 这里处理异常场景，具体如何处理取决于产品
        return [[UIViewController alloc] init];
    }
}


@end
