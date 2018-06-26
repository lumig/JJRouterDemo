//
//  AppDelegateRealize.m
//  JJKit
//
//  Created by luming on 2018/6/6.
//  Copyright © 2018年 luming. All rights reserved.
//
#import <UserNotifications/UserNotifications.h>

#import <objc/runtime.h>
#import "JJRouter.h"
@import UIKit;
@import Foundation;

#define MACRO_TOSTR(s) TOSTR(s)
#define TOSTR(s) #s
#define REPLACE_COLON(str) [[NSString stringWithFormat:@"%s", str] stringByReplacingOccurrencesOfString:@"_" withString:@":"]


//appdelegate代理方法的宏
#define APP_DELEGATE_METHOD_0    application_didFinishLaunchingWithOptions_
#define APP_DELEGATE_METHOD_1    applicationWillResignActive_
#define APP_DELEGATE_METHOD_2    applicationDidEnterBackground_
#define APP_DELEGATE_METHOD_3    applicationWillEnterForeground_
#define APP_DELEGATE_METHOD_4    applicationDidBecomeActive_
#define APP_DELEGATE_METHOD_5    applicationWillTerminate_
#define APP_DELEGATE_METHOD_6    applicationDidReceiveMemoryWarning_
#define APP_DELEGATE_METHOD_7    application_willChangeStatusBarFrame_
#define APP_DELEGATE_METHOD_8    application_didRegisterUserNotificationSettings_

#define APP_DELEGATE_METHOD_9    application_handleOpenURL_

#define APP_DELEGATE_METHOD_10    application_openURL_sourceApplication_annotation_

#define APP_DELEGATE_METHOD_11    application_openURL_options_

//
typedef void (^AppDelegateRestorationHandler)( void(^)(NSArray * __nullable restorableObjects));
#define APP_DELEGATE_METHOD_12    application_continueUserActivity_restorationHandler_
//


////////
#define APP_DELEGATE_METHOD_13    application_didRegisterForRemoteNotificationsWithDeviceToken_
#define APP_DELEGATE_METHOD_14    application_didFailToRegisterForRemoteNotificationsWithError_

//
typedef void (^AppDelegateCompletionHandler)( void(^)());
#define APP_DELEGATE_METHOD_15    application_handleActionWithIdentifier_forRemoteNotification_completionHandler_
#define APP_DELEGATE_METHOD_16    application_handleActionWithIdentifier_forRemoteNotification_withResponseInfo_completionHandler_
#define APP_DELEGATE_METHOD_17    application_handleActionWithIdentifier_forRemoteNotification_forLocalNotification_completionHandler_
#define APP_DELEGATE_METHOD_18    application_handleActionWithIdentifier_forRemoteNotification_forLocalNotification_withResponseInfo_completionHandler_
#define APP_DELEGATE_METHOD_19    application_didReceiveLocalNotification_
#define APP_DELEGATE_METHOD_20    application_didReceiveRemoteNotification_


typedef void (^AppDelegateFetchCompletionHandler)( void (^)(UIBackgroundFetchResult) );
#define APP_DELEGATE_METHOD_21    application_didReceiveRemoteNotification_fetchCompletionHandler_

typedef void (^AppDelegatePresentCompletionHandler)( void (^)(UNNotificationPresentationOptions) );
#define APP_DELEGATE_METHOD_22    userNotificationCenter_willPresentNotification_withCompletionHandler_
#define APP_DELEGATE_METHOD_23    userNotificationCenter_didReceiveNotificationResponse_withCompletionHandler_

////////
typedef void (^AppDelegateCompletionBoolHandler)( void (^)(BOOL) );
#define APP_DELEGATE_METHOD_24    application_performActionForShortcutItem_completionHandler_
#define APP_DELEGATE_METHOD_25    application_supportedInterfaceOrientationsForWindow_

//
#define APP_DELEGATE_BLOCK_JOINT(i) APP_DELEGATE_METHOD_##i         // 展开拼接 block
#define APP_DELEGATE_METHOD_JOINT(i) APP_DELEGATE_METHOD_##i##_##i    // 屏开拼接 方法
#define BLOCK_METHOD_DEFINE(i) APP_DELEGATE_BLOCK_JOINT(i) APP_DELEGATE_METHOD_JOINT(i)

//
typedef BOOL (^APP_DELEGATE_BLOCK_JOINT(0))(__unsafe_unretained id _self, UIApplication *application,  NSDictionary *launchOptions);
typedef void (^APP_DELEGATE_BLOCK_JOINT(1))(__unsafe_unretained id _self, UIApplication *application);
typedef void (^APP_DELEGATE_BLOCK_JOINT(2))(__unsafe_unretained id _self, UIApplication *application);
typedef void (^APP_DELEGATE_BLOCK_JOINT(3))(__unsafe_unretained id _self, UIApplication *application);
typedef void (^APP_DELEGATE_BLOCK_JOINT(4))(__unsafe_unretained id _self, UIApplication *application);
typedef void (^APP_DELEGATE_BLOCK_JOINT(5))(__unsafe_unretained id _self, UIApplication *application);
typedef void (^APP_DELEGATE_BLOCK_JOINT(6))(__unsafe_unretained id _self, UIApplication *application);
typedef void (^APP_DELEGATE_BLOCK_JOINT(7))(__unsafe_unretained id _self, UIApplication *application, CGRect newStatusBarFrame);
typedef void (^APP_DELEGATE_BLOCK_JOINT(8))(__unsafe_unretained id _self, UIApplication *application, UIUserNotificationSettings *notificationSettings);

typedef BOOL (^APP_DELEGATE_BLOCK_JOINT(9))(__unsafe_unretained id _self, UIApplication *application, NSURL *url);

typedef BOOL (^APP_DELEGATE_BLOCK_JOINT(10))(__unsafe_unretained id _self, UIApplication *application, NSURL *url, NSString*sourceApplication, id annotation);
typedef BOOL (^APP_DELEGATE_BLOCK_JOINT(11))(__unsafe_unretained id _self, UIApplication *application, NSURL *url, NSDictionary<UIApplicationOpenURLOptionsKey, id> * options);

typedef BOOL (^APP_DELEGATE_BLOCK_JOINT(12))(__unsafe_unretained id _self, UIApplication *application, NSUserActivity *userActivity, AppDelegateRestorationHandler restorationHandler);
typedef void (^APP_DELEGATE_BLOCK_JOINT(13))(__unsafe_unretained id _self, UIApplication *application, NSData *deviceToken);
typedef void (^APP_DELEGATE_BLOCK_JOINT(14))(__unsafe_unretained id _self, UIApplication *application, NSError *error);
typedef void (^APP_DELEGATE_BLOCK_JOINT(15))(__unsafe_unretained id _self, UIApplication *application, NSString *identifier, NSDictionary *userInfo, AppDelegateCompletionHandler completionHandler);
typedef void (^APP_DELEGATE_BLOCK_JOINT(16))(__unsafe_unretained id _self, UIApplication *application, NSString *identifier, NSDictionary *userInfo, NSDictionary *responseInfo, AppDelegateCompletionHandler completionHandler);
typedef void (^APP_DELEGATE_BLOCK_JOINT(17))(__unsafe_unretained id _self, UIApplication *application, NSString *identifier, UILocalNotification *notification, AppDelegateCompletionHandler completionHandler);
typedef void (^APP_DELEGATE_BLOCK_JOINT(18))(__unsafe_unretained id _self, UIApplication *application, NSString *identifier, UILocalNotification *notification, NSDictionary *responseInfo, AppDelegateCompletionHandler completionHandler);
typedef void (^APP_DELEGATE_BLOCK_JOINT(19))(__unsafe_unretained id _self, UIApplication *application, UILocalNotification *notification);
typedef void (^APP_DELEGATE_BLOCK_JOINT(20))(__unsafe_unretained id _self, UIApplication *application, NSDictionary *userInfo);
typedef void (^APP_DELEGATE_BLOCK_JOINT(21))(__unsafe_unretained id _self, UIApplication *application, NSDictionary *userInfo, AppDelegateFetchCompletionHandler completionHandler);
typedef void (^APP_DELEGATE_BLOCK_JOINT(22))(__unsafe_unretained id _self, UNUserNotificationCenter *center, UNNotification *notification, AppDelegatePresentCompletionHandler completionHandler);
typedef void (^APP_DELEGATE_BLOCK_JOINT(23))(__unsafe_unretained id _self, UNUserNotificationCenter *center, UNNotificationResponse *response, AppDelegateCompletionHandler completionHandler);

typedef BOOL (^APP_DELEGATE_BLOCK_JOINT(24))(__unsafe_unretained id _self, UIApplication *application, UIApplicationShortcutItem *response, AppDelegateCompletionBoolHandler completionHandler);
typedef BOOL (^APP_DELEGATE_BLOCK_JOINT(25))(__unsafe_unretained id _self, UIApplication *application, UIWindow *window);

// - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
static BLOCK_METHOD_DEFINE(0)(SEL targetSelector){
    
    return ^(__unsafe_unretained id _self, UIApplication *application,  NSDictionary *launchOptions){
        
        NSLog(@"====application_didFinishLaunchingWithOptions_");
        
        
        
        NSArray *outModules = [JJRouter openURL:@"router://JJAppDelegateModule/getDidFinishLaunchingModules"
                                            arg:nil
                                          error:nil
                                     completion:nil];
        
        BOOL result = YES;
        for (NSString *moduleStr in outModules) {
            
            Class cls = NSClassFromString(moduleStr);
            if (!cls) {
                NSLog(@"application delegate 组件*%@*不存在", moduleStr);
                continue;
            }
            
            NSString *selStr = REPLACE_COLON( MACRO_TOSTR( APP_DELEGATE_BLOCK_JOINT(0) ) );
            SEL sel = NSSelectorFromString(selStr);
            if (![cls respondsToSelector:sel]) {
                NSLog(@"application delegate 组件*%@*没有实现接口%@", moduleStr, selStr);
                continue;
            }
            // 通过签名初始化
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[cls methodSignatureForSelector:sel]];
            // 设置selector
            [inv setSelector:sel];
            // 设置target
            [inv setTarget:cls];
            //如果此消息有参数需要传入，那么就需要按照如下方法进行参数设置，需要注意的是，atIndex的下标必须从2开始。原因为：0 1 两个参数已经被target 和selector占用
            [inv setArgument:&(application) atIndex:2];
            [inv setArgument:&(launchOptions) atIndex:3];
            //消息调用
            [inv invoke];
            BOOL ret;
            [inv getReturnValue:&ret];
            if (!ret) {
                NSLog(@"组件*%@*接口%@调用返回NO", moduleStr, selStr);
                result = NO;
            }
        }
        
        
        // 10 以上消息转发
        //#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )
        //        Class NSBundleClass = NSClassFromString(@"NSBundle");
        //        if (NSBundleClass && ([NSBundleClass respondsToSelector:@selector(mainBundle)]) && ([[NSBundle mainBundle] bundleIdentifier] != nil) ){
        //            // 获取通知中心--单例
        //            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //            // 设置代理
        //            center.delegate = _self;
        //
        //            //获取用户的推送授权 iOS 10新方法
        //            [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
        //                                  completionHandler:^(BOOL granted, NSError * _Nullable error) {
        //
        //                                  }];
        //
        //            //获取当前的通知设置，UNNotificationSettings 是只读对象，readOnly，只能通过以下方法获取
        //            [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        //
        //            }];
        //        }
        //#endif
        
        
        return result;
    };
}


static BLOCK_METHOD_DEFINE(1)(SEL targetSelector){
    
    return ^(__unsafe_unretained id _self, UIApplication *application){
        
        NSLog(@"====applicationWillResignActive_");
        
        NSArray *outModules = [JJRouter openURL:@"router://JJAppDelegateModule/getWillResignActiveModules"
                                            arg:nil
                                          error:nil
                                     completion:nil];
        
        for (NSString *moduleStr in outModules) {
            
            Class cls = NSClassFromString(moduleStr);
            if (!cls) {
                NSLog(@"application delegate 组件*%@*不存在", moduleStr);
                continue;
            }
            
            NSString *selStr = REPLACE_COLON( MACRO_TOSTR( APP_DELEGATE_BLOCK_JOINT(1) ) );
            SEL sel = NSSelectorFromString(selStr);
            if (![cls respondsToSelector:sel]) {
                NSLog(@"application delegate 组件*%@*没有实现接口%@", moduleStr, selStr);
                continue;
            }
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[cls methodSignatureForSelector:sel]];
            
            [inv setSelector:sel];
            [inv setTarget:cls];
            [inv setArgument:&(application) atIndex:2];
            [inv invoke];
            
        }
    };
}


static BLOCK_METHOD_DEFINE(2)(SEL targetSelector){
    
    return ^(__unsafe_unretained id _self, UIApplication *application){
        
        
        NSLog(@"====applicationDidEnterBackground_");
        
        NSArray *outModules = [JJRouter openURL:@"router://JJAppDelegateModule/getApplicationDidEnterBackgroundModules"
                                            arg:nil
                                          error:nil
                                     completion:nil];
        
        for (NSString *moduleStr in outModules) {
            
            Class cls = NSClassFromString(moduleStr);
            if (!cls) {
                NSLog(@"application delegate 组件*%@*不存在", moduleStr);
                continue;
            }
            
            NSString *selStr = REPLACE_COLON( MACRO_TOSTR( APP_DELEGATE_BLOCK_JOINT(2) ) );
            SEL sel = NSSelectorFromString(selStr);
            if (![cls respondsToSelector:sel]) {
                NSLog(@"application delegate 组件*%@*没有实现接口%@", moduleStr, selStr);
                continue;
            }
            
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[cls methodSignatureForSelector:sel]];
            [inv setSelector:sel];
            [inv setTarget:cls];
            [inv setArgument:&(application) atIndex:2];
            [inv invoke];
            
        }
        
    };
}




static BLOCK_METHOD_DEFINE(3)(SEL targetSelector){
    
    return ^(__unsafe_unretained id _self, UIApplication *application){
        
        NSLog(@"====applicationWillEnterForeground");
        
        NSArray *outModules = [JJRouter openURL:@"router://JJAppDelegateModule/getApplicationWillEnterForegroundModules"
                                            arg:nil
                                          error:nil
                                     completion:nil];
        
        for (NSString *moduleStr in outModules) {
            
            Class cls = NSClassFromString(moduleStr);
            if (!cls) {
                NSLog(@"application delegate 组件*%@*不存在", moduleStr);
                continue;
            }
            
            NSString *selStr = REPLACE_COLON( MACRO_TOSTR( APP_DELEGATE_BLOCK_JOINT(3) ) );
            SEL sel = NSSelectorFromString(selStr);
            if (![cls respondsToSelector:sel]) {
                NSLog(@"application delegate 组件*%@*没有实现接口%@", moduleStr, selStr);
                continue;
            }
            
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[cls methodSignatureForSelector:sel]];
            [inv setSelector:sel];
            [inv setTarget:cls];
            [inv setArgument:&(application) atIndex:2];
            [inv invoke];
            
        }
    };
}



static BLOCK_METHOD_DEFINE(4)(SEL targetSelector){
    
    return ^(__unsafe_unretained id _self, UIApplication *application){
        
        
        NSLog(@"====applicationDidBecomeActive");
        
        NSArray *outModules = [JJRouter openURL:@"router://JJAppDelegateModule/getApplicationDidBecomeActiveModules"
                                            arg:nil
                                          error:nil
                                     completion:nil];
        
        for (NSString *moduleStr in outModules) {
            
            Class cls = NSClassFromString(moduleStr);
            if (!cls) {
                NSLog(@"application delegate 组件*%@*不存在", moduleStr);
                continue;
            }
            
            NSString *selStr = REPLACE_COLON( MACRO_TOSTR( APP_DELEGATE_BLOCK_JOINT(4) ) );
            SEL sel = NSSelectorFromString(selStr);
            if (![cls respondsToSelector:sel]) {
                NSLog(@"application delegate 组件*%@*没有实现接口%@", moduleStr, selStr);
                continue;
            }
            
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[cls methodSignatureForSelector:sel]];
            [inv setSelector:sel];
            [inv setTarget:cls];
            [inv setArgument:&(application) atIndex:2];
            [inv invoke];
            
        }
        
    };
}





static BLOCK_METHOD_DEFINE(5)(SEL targetSelector){
    
    return ^(__unsafe_unretained id _self, UIApplication *application){
        
        
        NSLog(@"====applicationWillTerminate");
        
        NSArray *outModules = [JJRouter openURL:@"router://JJAppDelegateModule/getApplicationWillTerminateModules"
                                            arg:nil
                                          error:nil
                                     completion:nil];
        
        for (NSString *moduleStr in outModules) {
            
            Class cls = NSClassFromString(moduleStr);
            if (!cls) {
                NSLog(@"application delegate 组件*%@*不存在", moduleStr);
                continue;
            }
            
            NSString *selStr = REPLACE_COLON( MACRO_TOSTR( APP_DELEGATE_BLOCK_JOINT(5) ) );
            SEL sel = NSSelectorFromString(selStr);
            if (![cls respondsToSelector:sel]) {
                NSLog(@"application delegate 组件*%@*没有实现接口%@", moduleStr, selStr);
                continue;
            }
            
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[cls methodSignatureForSelector:sel]];
            [inv setSelector:sel];
            [inv setTarget:cls];
            [inv setArgument:&(application) atIndex:2];
            [inv invoke];
            
        }
        
    };
}





static BLOCK_METHOD_DEFINE(6)(SEL targetSelector){
    
    return ^(__unsafe_unretained id _self, UIApplication *application){
        
        NSLog(@"====applicationDidReceiveMemoryWarning_");
        
        
        NSArray *outModules = [JJRouter openURL:@"router://JJAppDelegateModule/getDidReceiveMemoryWarningModules"
                                            arg:nil
                                          error:nil
                                     completion:nil];
        
        for (NSString *moduleStr in outModules) {
            
            Class cls = NSClassFromString(moduleStr);
            if (!cls) {
                NSLog(@"application delegate 组件*%@*不存在", moduleStr);
                continue;
            }
            
            NSString *selStr = REPLACE_COLON( MACRO_TOSTR( APP_DELEGATE_BLOCK_JOINT(6) ) );
            SEL sel = NSSelectorFromString(selStr);
            if (![cls respondsToSelector:sel]) {
                NSLog(@"application delegate 组件*%@*没有实现接口%@", moduleStr, selStr);
                continue;
            }
            
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[cls methodSignatureForSelector:sel]];
            [inv setSelector:sel];
            [inv setTarget:cls];
            [inv setArgument:&(application) atIndex:2];
            [inv invoke];
            
        }
        
    };
}







static BLOCK_METHOD_DEFINE(7)(SEL targetSelector){
    
    return ^(__unsafe_unretained id _self, UIApplication *application, CGRect newStatusBarFrame){
        
        NSLog(@"====applicationWillChangeStatusBarFrame");
        
        
        NSArray *outModules = [JJRouter openURL:@"router://JJAppDelegateModule/getApplicationWillChangeStatusBarFrameModules"
                                            arg:nil
                                          error:nil
                                     completion:nil];
        
        for (NSString *moduleStr in outModules) {
            
            Class cls = NSClassFromString(moduleStr);
            if (!cls) {
                NSLog(@"application delegate 组件*%@*不存在", moduleStr);
                continue;
            }
            
            NSString *selStr = REPLACE_COLON( MACRO_TOSTR( APP_DELEGATE_BLOCK_JOINT(7) ) );
            SEL sel = NSSelectorFromString(selStr);
            if (![cls respondsToSelector:sel]) {
                NSLog(@"application delegate 组件*%@*没有实现接口%@", moduleStr, selStr);
                continue;
            }
            
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[cls methodSignatureForSelector:sel]];
            [inv setSelector:sel];
            [inv setTarget:cls];
            [inv setArgument:&(application) atIndex:2];
            [inv setArgument:&(newStatusBarFrame) atIndex:3];
            [inv invoke];
            
        }
        
    };
}







//
static BLOCK_METHOD_DEFINE(8)(SEL targetSelector){
    
    return ^(__unsafe_unretained id _self, UIApplication *application, UIUserNotificationSettings *notificationSettings){
        
        NSLog(@"====application_didRegisterUserNotificationSettings_");
        
        
        NSArray *outModules = [JJRouter openURL:@"router://JJAppDelegateModule/getDidRegisterUserNotificationSettingsModules"
                                            arg:nil
                                          error:nil
                                     completion:nil];
        
        for (NSString *moduleStr in outModules) {
            
            Class cls = NSClassFromString(moduleStr);
            if (!cls) {
                NSLog(@"application delegate 组件*%@*不存在", moduleStr);
                continue;
            }
            
            NSString *selStr = REPLACE_COLON( MACRO_TOSTR( APP_DELEGATE_BLOCK_JOINT(8) ) );
            SEL sel = NSSelectorFromString(selStr);
            if (![cls respondsToSelector:sel]) {
                NSLog(@"application delegate 组件*%@*没有实现接口%@", moduleStr, selStr);
                continue;
            }
            
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[cls methodSignatureForSelector:sel]];
            [inv setSelector:sel];
            [inv setTarget:cls];
            [inv setArgument:&(application) atIndex:2];
            [inv setArgument:&(notificationSettings) atIndex:3];
            [inv invoke];
            
        }
        
    };
}




static BLOCK_METHOD_DEFINE(9)(SEL targetSelector){
    
    return ^(__unsafe_unretained id _self, UIApplication *application, NSURL *url){
        
        NSLog(@"====application_handleOpenURL_");
        
        NSArray *outModules = [JJRouter openURL:@"router://JJAppDelegateModule/getApplicationHandleOpenURLModules"
                                            arg:nil
                                          error:nil
                                     completion:nil];
        
        
        BOOL result = YES;
        
        for (NSString *moduleStr in outModules) {
            
            Class cls = NSClassFromString(moduleStr);
            if (!cls) {
                NSLog(@"application delegate 组件*%@*不存在", moduleStr);
                continue;
            }
            
            NSString *selStr = REPLACE_COLON( MACRO_TOSTR( APP_DELEGATE_BLOCK_JOINT(9) ) );
            SEL sel = NSSelectorFromString(selStr);
            if (![cls respondsToSelector:sel]) {
                NSLog(@"application delegate 组件*%@*没有实现接口%@", moduleStr, selStr);
                continue;
            }
            
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[cls methodSignatureForSelector:sel]];
            [inv setSelector:sel];
            [inv setTarget:cls];
            [inv setArgument:&(application) atIndex:2];
            [inv setArgument:&(url) atIndex:3];
            
            
            [inv invoke];
            BOOL ret;
            [inv getReturnValue:&ret];
            if (!ret) {
                NSLog(@"组件*%@*接口%@调用返回NO", moduleStr, selStr);
                result = NO;
            }
        }
        
        return result;
    };
}




// URL 从外部、内部跳转委托
static BLOCK_METHOD_DEFINE(10)(SEL targetSelector){
    
    return ^(__unsafe_unretained id _self, UIApplication *application, NSURL *url, NSString*sourceApplication, id annotation){
        
        
        NSLog(@"====application_openURL_sourceApplication_annotation_");
        
        
        NSArray *outModules = [JJRouter openURL:@"router://JJAppDelegateModule/getOpenURLModules"
                                            arg:nil
                                          error:nil
                                     completion:nil];
        
        for (NSString *moduleStr in outModules) {
            
            Class cls = NSClassFromString(moduleStr);
            if (!cls) {
                NSLog(@"application delegate 组件*%@*不存在", moduleStr);
                continue;
            }
            
            NSString *selStr = REPLACE_COLON( MACRO_TOSTR( APP_DELEGATE_BLOCK_JOINT(10) ) );
            SEL sel = NSSelectorFromString(selStr);
            if (![cls respondsToSelector:sel]) {
                NSLog(@"application delegate 组件*%@*没有实现接口%@", moduleStr, selStr);
                continue;
            }
            
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[cls methodSignatureForSelector:sel]];
            [inv setSelector:sel];
            [inv setTarget:cls];
            [inv setArgument:&(application) atIndex:2];
            [inv setArgument:&(url) atIndex:3];
            [inv setArgument:&(sourceApplication) atIndex:4];
            [inv setArgument:&(annotation) atIndex:5];
            
            [inv invoke];
            BOOL ret;
            [inv getReturnValue:&ret];
            if (ret) {
                return ret;
            }
        }
        
        return NO;
    };
}




static BLOCK_METHOD_DEFINE(11)(SEL targetSelector){
    
    return ^(__unsafe_unretained id _self, UIApplication *application, NSURL *url, NSDictionary<UIApplicationOpenURLOptionsKey, id> * options){
        
        
        
        NSLog(@"====application_openURL_options_");
        
        BOOL result = YES;
        NSArray *outModules = [JJRouter openURL:@"router://JJAppDelegateModule/getApplicationOpenURLOptionsModules"
                                            arg:nil
                                          error:nil
                                     completion:nil];
        
        for (NSString *moduleStr in outModules) {
            
            Class cls = NSClassFromString(moduleStr);
            if (!cls) {
                NSLog(@"application delegate 组件*%@*不存在", moduleStr);
                continue;
            }
            
            NSString *selStr = REPLACE_COLON( MACRO_TOSTR( APP_DELEGATE_BLOCK_JOINT(11) ) );
            SEL sel = NSSelectorFromString(selStr);
            if (![cls respondsToSelector:sel]) {
                NSLog(@"application delegate 组件*%@*没有实现接口%@", moduleStr, selStr);
                continue;
            }
            
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[cls methodSignatureForSelector:sel]];
            [inv setSelector:sel];
            [inv setTarget:cls];
            [inv setArgument:&(application) atIndex:2];
            [inv setArgument:&(url) atIndex:3];
            [inv setArgument:&(options) atIndex:4];
            
            [inv invoke];
            BOOL ret;
            [inv getReturnValue:&ret];
            if (!ret) {
                NSLog(@"组件*%@*接口%@调用返回NO", moduleStr, selStr);
                result = NO;
            }
        }
        
        return result;
    };
}



static BLOCK_METHOD_DEFINE(12)(SEL targetSelector){
    
    return ^(__unsafe_unretained id _self, UIApplication *application, NSUserActivity *userActivity, AppDelegateRestorationHandler restorationHandler){
        
        
        NSLog(@"====application_continueUserActivity_restorationHandler_");
        
        
        NSArray *outModules = [JJRouter openURL:@"router://JJAppDelegateModule/getContinueUserActivityModules"
                                            arg:nil
                                          error:nil
                                     completion:nil];
        
        for (NSString *moduleStr in outModules) {
            
            Class cls = NSClassFromString(moduleStr);
            if (!cls) {
                NSLog(@"application delegate 组件*%@*不存在", moduleStr);
                continue;
            }
            
            NSString *selStr = REPLACE_COLON( MACRO_TOSTR( APP_DELEGATE_BLOCK_JOINT(12) ) );
            SEL sel = NSSelectorFromString(selStr);
            if (![cls respondsToSelector:sel]) {
                NSLog(@"application delegate 组件*%@*没有实现接口%@", moduleStr, selStr);
                continue;
            }
            
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[cls methodSignatureForSelector:sel]];
            [inv setSelector:sel];
            [inv setTarget:cls];
            [inv setArgument:&(application) atIndex:2];
            [inv setArgument:&(userActivity) atIndex:3];
            [inv setArgument:&(restorationHandler) atIndex:4];
            
            [inv invoke];
            BOOL ret;
            [inv getReturnValue:&ret];
            if (ret) {
                return ret;
            }
        }
        
        return NO;
    };
}





//
static BLOCK_METHOD_DEFINE(13)(SEL targetSelector){
    
    return ^(__unsafe_unretained id _self, UIApplication *application, NSData *deviceToken){
        
        NSLog(@"====didRegisterForRemoteNotificationsWithDeviceToken");
        
        
        NSArray *outModules = [JJRouter openURL:@"router://JJAppDelegateModule/getDidRegisterForRemoteNotificationsWithDeviceTokenModules"
                                            arg:nil
                                          error:nil
                                     completion:nil];
        
        for (NSString *moduleStr in outModules) {
            
            Class cls = NSClassFromString(moduleStr);
            if (!cls) {
                NSLog(@"application delegate 组件*%@*不存在", moduleStr);
                continue;
            }
            
            NSString *selStr = REPLACE_COLON( MACRO_TOSTR( APP_DELEGATE_BLOCK_JOINT(13) ) );
            SEL sel = NSSelectorFromString(selStr);
            if (![cls respondsToSelector:sel]) {
                NSLog(@"application delegate 组件*%@*没有实现接口%@", moduleStr, selStr);
                continue;
            }
            
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[cls methodSignatureForSelector:sel]];
            [inv setSelector:sel];
            [inv setTarget:cls];
            [inv setArgument:&(application) atIndex:2];
            [inv setArgument:&(deviceToken) atIndex:3];
            [inv invoke];
        }
    };
}




//
static BLOCK_METHOD_DEFINE(14)(SEL targetSelector){
    
    return ^(__unsafe_unretained id _self, UIApplication *application, NSError *error){
        
        NSLog(@"====didFailToRegisterForRemoteNotificationsWithError");
        
        
        NSArray *outModules = [JJRouter openURL:@"router://JJAppDelegateModule/getDidFailToRegisterForRemoteNotificationsWithErrorModules"
                                            arg:nil
                                          error:nil
                                     completion:nil];
        
        for (NSString *moduleStr in outModules) {
            
            Class cls = NSClassFromString(moduleStr);
            if (!cls) {
                NSLog(@"application delegate 组件*%@*不存在", moduleStr);
                continue;
            }
            
            NSString *selStr = REPLACE_COLON( MACRO_TOSTR( APP_DELEGATE_BLOCK_JOINT(14) ) );
            SEL sel = NSSelectorFromString(selStr);
            if (![cls respondsToSelector:sel]) {
                NSLog(@"application delegate 组件*%@*没有实现接口%@", moduleStr, selStr);
                continue;
            }
            
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[cls methodSignatureForSelector:sel]];
            [inv setSelector:sel];
            [inv setTarget:cls];
            [inv setArgument:&(application) atIndex:2];
            [inv setArgument:&(error) atIndex:3];
            [inv invoke];
        }
    };
}


//
static BLOCK_METHOD_DEFINE(15)(SEL targetSelector){
    
    return ^(__unsafe_unretained id _self, UIApplication *application, NSString *identifier, NSDictionary *userInfo, AppDelegateCompletionHandler completionHandler){
        
        NSLog(@"====handleActionWithIdentifier");
        
        
        NSArray *outModules = [JJRouter openURL:@"router://JJAppDelegateModule/getHandleActionWithIdentifierForRemoteNotificationModules"
                                            arg:nil
                                          error:nil
                                     completion:nil];
        
        for (NSString *moduleStr in outModules) {
            
            Class cls = NSClassFromString(moduleStr);
            if (!cls) {
                NSLog(@"application delegate 组件*%@*不存在", moduleStr);
                continue;
            }
            
            NSString *selStr = REPLACE_COLON( MACRO_TOSTR( APP_DELEGATE_BLOCK_JOINT(15) ) );
            SEL sel = NSSelectorFromString(selStr);
            if (![cls respondsToSelector:sel]) {
                NSLog(@"application delegate 组件*%@*没有实现接口%@", moduleStr, selStr);
                continue;
            }
            
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[cls methodSignatureForSelector:sel]];
            [inv setSelector:sel];
            [inv setTarget:cls];
            [inv setArgument:&(application) atIndex:2];
            [inv setArgument:&(identifier) atIndex:3];
            [inv setArgument:&(userInfo) atIndex:4];
            [inv setArgument:&(completionHandler) atIndex:5];
            [inv invoke];
        }
    };
}




//
static BLOCK_METHOD_DEFINE(16)(SEL targetSelector){
    
    return ^(__unsafe_unretained id _self, UIApplication *application, NSString *identifier, NSDictionary *userInfo, NSDictionary *responseInfo, AppDelegateCompletionHandler completionHandler){
        
        NSLog(@"====HandleActionWithIdentifierForRemoteNotificationWithResponseInfoModules");
        
        
        NSArray *outModules = [JJRouter openURL:@"router://JJAppDelegateModule/getHandleActionWithIdentifierForRemoteNotificationWithResponseInfoModules"
                                            arg:nil
                                          error:nil
                                     completion:nil];
        
        for (NSString *moduleStr in outModules) {
            
            Class cls = NSClassFromString(moduleStr);
            if (!cls) {
                NSLog(@"application delegate 组件*%@*不存在", moduleStr);
                continue;
            }
            
            NSString *selStr = REPLACE_COLON( MACRO_TOSTR( APP_DELEGATE_BLOCK_JOINT(16) ) );
            SEL sel = NSSelectorFromString(selStr);
            if (![cls respondsToSelector:sel]) {
                NSLog(@"application delegate 组件*%@*没有实现接口%@", moduleStr, selStr);
                continue;
            }
            
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[cls methodSignatureForSelector:sel]];
            [inv setSelector:sel];
            [inv setTarget:cls];
            [inv setArgument:&(application) atIndex:2];
            [inv setArgument:&(identifier) atIndex:3];
            [inv setArgument:&(userInfo) atIndex:4];
            [inv setArgument:&(responseInfo) atIndex:5];
            [inv setArgument:&(completionHandler) atIndex:6];
            [inv invoke];
        }
    };
}




//
static BLOCK_METHOD_DEFINE(17)(SEL targetSelector){
    
    return ^(__unsafe_unretained id _self, UIApplication *application, NSString *identifier, UILocalNotification *notification, AppDelegateCompletionHandler completionHandler){
        
        NSLog(@"====HandleActionWithIdentifierForLocalNotificationModules");
        
        
        NSArray *outModules = [JJRouter openURL:@"router://JJAppDelegateModule/getHandleActionWithIdentifierForLocalNotificationModules"
                                            arg:nil
                                          error:nil
                                     completion:nil];
        
        for (NSString *moduleStr in outModules) {
            
            Class cls = NSClassFromString(moduleStr);
            if (!cls) {
                NSLog(@"application delegate 组件*%@*不存在", moduleStr);
                continue;
            }
            
            NSString *selStr = REPLACE_COLON( MACRO_TOSTR( APP_DELEGATE_BLOCK_JOINT(17) ) );
            SEL sel = NSSelectorFromString(selStr);
            if (![cls respondsToSelector:sel]) {
                NSLog(@"application delegate 组件*%@*没有实现接口%@", moduleStr, selStr);
                continue;
            }
            
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[cls methodSignatureForSelector:sel]];
            [inv setSelector:sel];
            [inv setTarget:cls];
            [inv setArgument:&(application) atIndex:2];
            [inv setArgument:&(identifier) atIndex:3];
            [inv setArgument:&(notification) atIndex:4];
            [inv setArgument:&(completionHandler) atIndex:5];
            [inv invoke];
        }
    };
}



//
static BLOCK_METHOD_DEFINE(18)(SEL targetSelector){
    
    return ^(__unsafe_unretained id _self, UIApplication *application, NSString *identifier, UILocalNotification *notification, NSDictionary *responseInfo, AppDelegateCompletionHandler completionHandler){
        
        NSLog(@"====HandleActionWithIdentifierForLocalNotificationWithResponseInfoModules");
        
        
        NSArray *outModules = [JJRouter openURL:@"router://JJAppDelegateModule/getHandleActionWithIdentifierForLocalNotificationWithResponseInfoModules"
                                            arg:nil
                                          error:nil
                                     completion:nil];
        
        for (NSString *moduleStr in outModules) {
            
            Class cls = NSClassFromString(moduleStr);
            if (!cls) {
                NSLog(@"application delegate 组件*%@*不存在", moduleStr);
                continue;
            }
            
            NSString *selStr = REPLACE_COLON( MACRO_TOSTR( APP_DELEGATE_BLOCK_JOINT(18) ) );
            SEL sel = NSSelectorFromString(selStr);
            if (![cls respondsToSelector:sel]) {
                NSLog(@"application delegate 组件*%@*没有实现接口%@", moduleStr, selStr);
                continue;
            }
            
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[cls methodSignatureForSelector:sel]];
            [inv setSelector:sel];
            [inv setTarget:cls];
            [inv setArgument:&(application) atIndex:2];
            [inv setArgument:&(identifier) atIndex:3];
            [inv setArgument:&(notification) atIndex:4];
            [inv setArgument:&(responseInfo) atIndex:5];
            [inv setArgument:&(completionHandler) atIndex:6];
            [inv invoke];
        }
    };
}




//
static BLOCK_METHOD_DEFINE(19)(SEL targetSelector){
    
    return ^(__unsafe_unretained id _self, UIApplication *application, UILocalNotification *notification){
        
        NSLog(@"====DidReceiveLocalNotificationModules");
        
        
        NSArray *outModules = [JJRouter openURL:@"router://JJAppDelegateModule/getDidReceiveLocalNotificationModules"
                                            arg:nil
                                          error:nil
                                     completion:nil];
        
        for (NSString *moduleStr in outModules) {
            
            Class cls = NSClassFromString(moduleStr);
            if (!cls) {
                NSLog(@"application delegate 组件*%@*不存在", moduleStr);
                continue;
            }
            
            NSString *selStr = REPLACE_COLON( MACRO_TOSTR( APP_DELEGATE_BLOCK_JOINT(19) ) );
            SEL sel = NSSelectorFromString(selStr);
            if (![cls respondsToSelector:sel]) {
                NSLog(@"application delegate 组件*%@*没有实现接口%@", moduleStr, selStr);
                continue;
            }
            
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[cls methodSignatureForSelector:sel]];
            [inv setSelector:sel];
            [inv setTarget:cls];
            [inv setArgument:&(application) atIndex:2];
            [inv setArgument:&(notification) atIndex:3];
            [inv invoke];
        }
    };
}







//

static BLOCK_METHOD_DEFINE(20)(SEL targetSelector){
    
    return ^(__unsafe_unretained id _self, UIApplication *application, NSDictionary *userInfo){
        
        NSLog(@"====didReceiveRemoteNotification");
        
        
        NSArray *outModules = [JJRouter openURL:@"router://JJAppDelegateModule/getDidReceiveRemoteNotificationModules"
                                            arg:nil
                                          error:nil
                                     completion:nil];
        
        for (NSString *moduleStr in outModules) {
            
            Class cls = NSClassFromString(moduleStr);
            if (!cls) {
                NSLog(@"application delegate 组件*%@*不存在", moduleStr);
                continue;
            }
            
            NSString *selStr = REPLACE_COLON( MACRO_TOSTR( APP_DELEGATE_BLOCK_JOINT(20) ) );
            SEL sel = NSSelectorFromString(selStr);
            if (![cls respondsToSelector:sel]) {
                NSLog(@"application delegate 组件*%@*没有实现接口%@", moduleStr, selStr);
                continue;
            }
            
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[cls methodSignatureForSelector:sel]];
            [inv setSelector:sel];
            [inv setTarget:cls];
            [inv setArgument:&(application) atIndex:2];
            [inv setArgument:&(userInfo) atIndex:3];
            [inv invoke];
        }
    };
}



//

static BLOCK_METHOD_DEFINE(21)(SEL targetSelector){
    
    return ^(__unsafe_unretained id _self, UIApplication *application, NSDictionary *userInfo, AppDelegateFetchCompletionHandler completionHandler){
        
        NSLog(@"====didReceiveRemoteNotificationFetchCompletionHandler");
        
        
        NSArray *outModules = [JJRouter openURL:@"router://JJAppDelegateModule/getDidReceiveRemoteNotificationFetchCompletionHandlerModules"
                                            arg:nil
                                          error:nil
                                     completion:nil];
        
        for (NSString *moduleStr in outModules) {
            
            Class cls = NSClassFromString(moduleStr);
            if (!cls) {
                NSLog(@"application delegate 组件*%@*不存在", moduleStr);
                continue;
            }
            
            NSString *selStr = REPLACE_COLON( MACRO_TOSTR( APP_DELEGATE_BLOCK_JOINT(21) ) );
            SEL sel = NSSelectorFromString(selStr);
            if (![cls respondsToSelector:sel]) {
                NSLog(@"application delegate 组件*%@*没有实现接口%@", moduleStr, selStr);
                continue;
            }
            
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[cls methodSignatureForSelector:sel]];
            [inv setSelector:sel];
            [inv setTarget:cls];
            [inv setArgument:&(application) atIndex:2];
            [inv setArgument:&(userInfo) atIndex:3];
            [inv setArgument:&(completionHandler) atIndex:4];
            [inv invoke];
        }
    };
}



//

static BLOCK_METHOD_DEFINE(22)(SEL targetSelector){
    
    return ^(__unsafe_unretained id _self, UNUserNotificationCenter *center, UNNotification *notification, AppDelegatePresentCompletionHandler completionHandler){
        
        NSLog(@"====userNotificationCenterWillPresentNotification");
        
        
        NSArray *outModules = [JJRouter openURL:@"router://JJAppDelegateModule/getUserNotificationCenterWillPresentNotificationModules"
                                            arg:nil
                                          error:nil
                                     completion:nil];
        
        for (NSString *moduleStr in outModules) {
            
            Class cls = NSClassFromString(moduleStr);
            if (!cls) {
                NSLog(@"application delegate 组件*%@*不存在", moduleStr);
                continue;
            }
            
            NSString *selStr = REPLACE_COLON( MACRO_TOSTR( APP_DELEGATE_BLOCK_JOINT(22) ) );
            SEL sel = NSSelectorFromString(selStr);
            if (![cls respondsToSelector:sel]) {
                NSLog(@"application delegate 组件*%@*没有实现接口%@", moduleStr, selStr);
                continue;
            }
            
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[cls methodSignatureForSelector:sel]];
            [inv setSelector:sel];
            [inv setTarget:cls];
            [inv setArgument:&(center) atIndex:2];
            [inv setArgument:&(notification) atIndex:3];
            [inv setArgument:&(completionHandler) atIndex:4];
            [inv invoke];
        }
    };
}






//

static BLOCK_METHOD_DEFINE(23)(SEL targetSelector){
    
    return ^(__unsafe_unretained id _self, UNUserNotificationCenter *center, UNNotificationResponse *response, AppDelegateCompletionHandler completionHandler){
        
        NSLog(@"====userNotificationCenterDidReceiveNotificationResponse");
        
        
        NSArray *outModules = [JJRouter openURL:@"router://JJAppDelegateModule/getUserNotificationCenterDidReceiveNotificationResponseModules"
                                            arg:nil
                                          error:nil
                                     completion:nil];
        
        for (NSString *moduleStr in outModules) {
            
            Class cls = NSClassFromString(moduleStr);
            if (!cls) {
                NSLog(@"application delegate 组件*%@*不存在", moduleStr);
                continue;
            }
            
            NSString *selStr = REPLACE_COLON( MACRO_TOSTR( APP_DELEGATE_BLOCK_JOINT(23) ) );
            SEL sel = NSSelectorFromString(selStr);
            if (![cls respondsToSelector:sel]) {
                NSLog(@"application delegate 组件*%@*没有实现接口%@", moduleStr, selStr);
                continue;
            }
            
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[cls methodSignatureForSelector:sel]];
            [inv setSelector:sel];
            [inv setTarget:cls];
            [inv setArgument:&(center) atIndex:2];
            [inv setArgument:&(response) atIndex:3];
            [inv setArgument:&(completionHandler) atIndex:4];
            [inv invoke];
        }
    };
}






//

static BLOCK_METHOD_DEFINE(24)(SEL targetSelector){
    
    
    
    
    return ^(__unsafe_unretained id _self, UIApplication *application, UIApplicationShortcutItem *response, AppDelegateCompletionBoolHandler completionHandler){
        
        
        NSLog(@"====applicationPerformActionForShortcutItemCompletionHandler");
        
        
        NSArray *outModules = [JJRouter openURL:@"router://JJAppDelegateModule/getApplicationPerformActionForShortcutItemCompletionHandler"
                                            arg:nil
                                          error:nil
                                     completion:nil];
        
        
        BOOL result = NO;
        
        for (NSString *moduleStr in outModules) {
            
            Class cls = NSClassFromString(moduleStr);
            if (!cls) {
                NSLog(@"application delegate 组件*%@*不存在", moduleStr);
                continue;
            }
            
            NSString *selStr = REPLACE_COLON( MACRO_TOSTR( APP_DELEGATE_BLOCK_JOINT(24) ) );
            SEL sel = NSSelectorFromString(selStr);
            if (![cls respondsToSelector:sel]) {
                NSLog(@"application delegate 组件*%@*没有实现接口%@", moduleStr, selStr);
                continue;
            }
            
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[cls methodSignatureForSelector:sel]];
            [inv setSelector:sel];
            [inv setTarget:cls];
            [inv setArgument:&(application) atIndex:2];
            [inv setArgument:&(response) atIndex:3];
            [inv setArgument:&(completionHandler) atIndex:4];
            [inv invoke];
        }
        
        return result;
    };
}

static BLOCK_METHOD_DEFINE(25)(SEL targetSelector){
    
    return ^(__unsafe_unretained id _self, UIApplication *application, UIWindow *window){
        
        
        NSLog(@"====SupportedInterfaceOrientationsForWindow");
        
        
        NSArray *outModules = [JJRouter openURL:@"router://JJAppDelegateModule/getSupportedInterfaceOrientationsForWindow"
                                            arg:nil
                                          error:nil
                                     completion:nil];
        
        
        BOOL result = NO;
        
        for (NSString *moduleStr in outModules) {
            
            Class cls = NSClassFromString(moduleStr);
            if (!cls) {
                NSLog(@"application delegate 组件*%@*不存在", moduleStr);
                continue;
            }
            
            NSString *selStr = REPLACE_COLON( MACRO_TOSTR( APP_DELEGATE_BLOCK_JOINT(25) ) );
            SEL sel = NSSelectorFromString(selStr);
            if (![cls respondsToSelector:sel]) {
                NSLog(@"application delegate 组件*%@*没有实现接口%@", moduleStr, selStr);
                continue;
            }
            
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[cls methodSignatureForSelector:sel]];
            [inv setSelector:sel];
            [inv setTarget:cls];
            [inv setArgument:&(application) atIndex:2];
            [inv setArgument:&(window) atIndex:3];
            [inv invoke];
        }
        
        return result;
    };
}

// 替换、解耦AppDelegate方法
static BOOL replaceMethodWithBlock(Class c, SEL origSEL, SEL newSEL, id block) {
    
    if ([c instancesRespondToSelector:newSEL]) {
        return YES;
    }
    Method origMethod = class_getInstanceMethod(c, origSEL);
    IMP impl = imp_implementationWithBlock(block);
    if (!class_addMethod(c, newSEL, impl, method_getTypeEncoding(origMethod))) {
        return NO;
    }else {
        Method newMethod = class_getInstanceMethod(c, newSEL);
        if (class_addMethod(c, origSEL, method_getImplementation(newMethod), method_getTypeEncoding(origMethod))) {
            class_replaceMethod(c, newSEL, method_getImplementation(origMethod), method_getTypeEncoding(newMethod));
        }else {
            method_exchangeImplementations(origMethod, newMethod);
        }
    }
    return YES;
}






@interface AppDelegateRealize : NSObject


@end


@implementation AppDelegateRealize

// 替换appdelegate 中所有方法

JJROUTER_EXTERN_METHOD(AppDelegateRealize, swizzleJJAppDelegateMethod, arg, callback) {
    
    static BOOL isReplaceMethod = NO;
    if (isReplaceMethod) {
        return nil;
    }
    isReplaceMethod = YES;
    
    //
    
    //
#define CUSTOMIZE_APP_DELEGATE(class,i) do{\
NSString *selStr = REPLACE_COLON( MACRO_TOSTR( APP_DELEGATE_BLOCK_JOINT(i) ) );\
SEL orgSel = NSSelectorFromString(selStr);\
SEL newSel = NSSelectorFromString([@"JJsh_" stringByAppendingString:selStr]);\
replaceMethodWithBlock(class, orgSel, newSel, APP_DELEGATE_METHOD_JOINT(i)(newSel));\
}while(0)
    
    
    Class app_class =  NSClassFromString(@"AppDelegate");
    
    CUSTOMIZE_APP_DELEGATE(app_class, 0);
    CUSTOMIZE_APP_DELEGATE(app_class, 1);
    CUSTOMIZE_APP_DELEGATE(app_class, 2);
    CUSTOMIZE_APP_DELEGATE(app_class, 3);
    CUSTOMIZE_APP_DELEGATE(app_class, 4);
    CUSTOMIZE_APP_DELEGATE(app_class, 5);
    CUSTOMIZE_APP_DELEGATE(app_class, 6);
    CUSTOMIZE_APP_DELEGATE(app_class, 7);
    
    
    CUSTOMIZE_APP_DELEGATE(app_class, 8);
    CUSTOMIZE_APP_DELEGATE(app_class, 9);
    CUSTOMIZE_APP_DELEGATE(app_class, 10);
    
    // application_openURL_options_方法9.0才支持，加了该方法 application_openURL_sourceApplication_annotation_ 将不会调用
    CUSTOMIZE_APP_DELEGATE(app_class, 11);
    
    CUSTOMIZE_APP_DELEGATE(app_class, 12);
    CUSTOMIZE_APP_DELEGATE(app_class, 13);
    CUSTOMIZE_APP_DELEGATE(app_class, 14);
    CUSTOMIZE_APP_DELEGATE(app_class, 15);
    CUSTOMIZE_APP_DELEGATE(app_class, 16);
    CUSTOMIZE_APP_DELEGATE(app_class, 17);
    CUSTOMIZE_APP_DELEGATE(app_class, 18);
    CUSTOMIZE_APP_DELEGATE(app_class, 19);
    CUSTOMIZE_APP_DELEGATE(app_class, 20);
    CUSTOMIZE_APP_DELEGATE(app_class, 21);
    
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )
    CUSTOMIZE_APP_DELEGATE(app_class, 22);
    CUSTOMIZE_APP_DELEGATE(app_class, 23);
    
#endif
    
    CUSTOMIZE_APP_DELEGATE(app_class, 24);
    CUSTOMIZE_APP_DELEGATE(app_class, 25);
    
    return nil;
}



@end

