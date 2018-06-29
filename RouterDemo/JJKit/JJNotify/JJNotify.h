//
//  JJNotify.h
//  MIGUDEMO
//
//  Created by luming on 2018/6/5.
//  Copyright © 2018年 luming. All rights reserved.
//
//通知block使用方式，不用dealloc中再注销
#import <Foundation/Foundation.h>
#define MG_EVENT_KEY(name) static NSString *const name = @#name;

typedef void (^NotifyBlock)(__nullable id info);
@interface JJNotify : NSObject

/**
 通知
 
 @param eventName 事件名
 @param info 传参
 */
+ (void)notify:(nonnull NSString *)eventName info:(nullable id)info;

/**
 注册成为观察者

 @param eventName 事件名
 @param instance self
 @param block 事件处理
 */
+ (void)registerNotify:(nonnull NSString *)eventName instance:(nonnull id)instance block:(nullable NotifyBlock)block;
@end
