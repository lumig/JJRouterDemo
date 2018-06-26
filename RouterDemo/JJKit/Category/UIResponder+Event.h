//
//  UIResponder+Event.h
//  JJKit
//
//  Created by luming on 2018/6/5.
//  Copyright © 2018年 luming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>

#define MG_EVENT_KEY(name) static NSString *const name = @#name;
typedef void (^EventBlock)(__nullable id info);

@interface UIResponder (Event)

- (void)routerEvent:(nonnull NSString *)eventName info:(nullable id)info;

- (void)registerEvent:(nonnull NSString *)eventName block:(nullable EventBlock)block next:(BOOL)needNext;

@end
