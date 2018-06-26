//
//  JJWebVCModuleProvider.h
//  WowTemplate
//
//  Created by luming on 2018/6/15.
//  Copyright © 2018年 luming. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JJBaseModuleProvider.h"
@interface JJWebVCModuleProvider : JJBaseModuleProvider

- (UIViewController *)viewControllerWithInfo:(id)userInfo needNew:(BOOL)needNew callback:(JJModuleCallbackBlock)callback;

@end
