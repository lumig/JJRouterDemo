//
//  JJBaseProtocol.h
//  JJKit
//
//  Created by luming on 2018/6/5.
//  Copyright © 2018年 luming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^JJModuleCallbackBlock)(id info);

@protocol JJBaseProtocol <NSObject>

@optional

-(UIViewController *)viewControllerWithInfo:(id)userInfo needNew:(BOOL)needNew callback:(JJModuleCallbackBlock)callback;

-(UIView *)viewWithInfo:(id)userInfo needNew:(BOOL)needNew callback:(JJModuleCallbackBlock)callback;
@end
