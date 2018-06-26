//
//  Target_A.m
//  RouterDemo
//
//  Created by luming on 2018/6/26.
//  Copyright © 2018年 luming. All rights reserved.
//

#import "Target_A.h"
#import "JJLoginViewController.h"
@implementation Target_A

- (UIViewController *)Action_showLoginController:(NSDictionary *)param
{
    JJLoginViewController *vc =[[JJLoginViewController alloc] init];
    
    return vc;
}

@end
