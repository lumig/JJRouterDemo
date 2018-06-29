//
//  NSObject+CurrentNav.h
//  JJKit
//
//  Created by luming on 2018/6/5.
//  Copyright © 2018年 luming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (CurrentNav)

/**
 获取当前的导航栏控制器
 */
@property (nonatomic, strong, readonly) UINavigationController *currentNav;

@end
