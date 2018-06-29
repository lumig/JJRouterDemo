//
//  JJAppDelegateModule.h
//  JJKit
//
//  Created by luming on 2018/6/6.
//  Copyright © 2018年 luming. All rights reserved.
//

#import "JJAppDelegateModule.h"

#import "AppDelegateRealize.h"

#import "JJRouter.h"

static NSMutableDictionary<NSString *, NSArray *> *gAppdelegateModules = nil;



/*
 return nil
 arg: NSArray
 any://JJAppDelegateModule/setDidFinishLaunchingModules
 */

/*
 return NSArray
 arg: nil
 any://JJAppDelegateModule/getDidFinishLaunchingModules
 */




/*
 return nil
 arg: NSArray
 any://JJAppDelegateModule/setOpenURLModules
 */

/*
 return NSArray
 arg: nil
 any://JJAppDelegateModule/getOpenURLModules
 */


/*
 return nil
 arg: nil
 any://JJAppDelegateModule/run
 */



@implementation JJAppDelegateModule

+ (NSMutableDictionary *)appModules
{
    if (!gAppdelegateModules) {
        gAppdelegateModules = [[NSMutableDictionary alloc] init];
    }
    return gAppdelegateModules;
}

+ (void) setModules:(NSArray *)modules key:(NSString *)key {
    if (modules && key) {
        NSMutableDictionary *appModules = [JJAppDelegateModule appModules];
        [appModules setObject:modules forKey:key];
    }
}


+ (NSArray *) getModulesWithkey:(NSString *)key {
    if (!key) return nil;
    NSMutableDictionary *appModules = [JJAppDelegateModule appModules];
    return appModules[key];
}


JJROUTER_EXTERN_METHOD(JJAppDelegateModule, run, arg, callback) {
    
    @autoreleasepool {
        // 替换appdelegate方法
        [JJRouter openURL:@"router://AppDelegateRealize/swizzleJJAppDelegateMethod"
                      arg:nil
                    error:nil
               completion:nil];
        
    }
    return nil;
}


// ------------------------
JJROUTER_EXTERN_METHOD(JJAppDelegateModule, setDidFinishLaunchingModules, arg, callback) {
    
    [JJAppDelegateModule setModules:arg[JJRouterParamsOption] key:@"DidFinishLaunchingModules"];
    return nil;
}


JJROUTER_EXTERN_METHOD(JJAppDelegateModule, getDidFinishLaunchingModules, arg, callback) {
    return [JJAppDelegateModule getModulesWithkey:@"DidFinishLaunchingModules"];
}


// ------------------------
JJROUTER_EXTERN_METHOD(JJAppDelegateModule, setApplicationDidEnterBackgroundModules, arg, callback) {
    
    [JJAppDelegateModule setModules:arg[JJRouterParamsOption] key:@"ApplicationDidEnterBackgroundModules"];
    return nil;
}


JJROUTER_EXTERN_METHOD(JJAppDelegateModule, getApplicationDidEnterBackgroundModules, arg, callback) {
    return [JJAppDelegateModule getModulesWithkey:@"ApplicationDidEnterBackgroundModules"];
}




// ------------------------
JJROUTER_EXTERN_METHOD(JJAppDelegateModule, setApplicationWillEnterForegroundModules, arg, callback) {
    [JJAppDelegateModule setModules:arg[JJRouterParamsOption] key:@"ApplicationWillEnterForegroundModules"];
    return nil;
}

JJROUTER_EXTERN_METHOD(JJAppDelegateModule, getApplicationWillEnterForegroundModules, arg, callback) {
    
    return [JJAppDelegateModule getModulesWithkey:@"ApplicationWillEnterForegroundModules"];
}





// ------------------------
JJROUTER_EXTERN_METHOD(JJAppDelegateModule, setApplicationDidBecomeActiveModules, arg, callback) {
    [JJAppDelegateModule setModules:arg[JJRouterParamsOption] key:@"ApplicationDidBecomeActiveModules"];
    return nil;
}

JJROUTER_EXTERN_METHOD(JJAppDelegateModule, getApplicationDidBecomeActiveModules, arg, callback) {
    
    return [JJAppDelegateModule getModulesWithkey:@"ApplicationDidBecomeActiveModules"];
}





// ------------------------
JJROUTER_EXTERN_METHOD(JJAppDelegateModule, setApplicationWillTerminateModules, arg, callback) {
    [JJAppDelegateModule setModules:arg[JJRouterParamsOption] key:@"ApplicationWillTerminateModules"];
    return nil;
}

JJROUTER_EXTERN_METHOD(JJAppDelegateModule, getApplicationWillTerminateModules, arg, callback) {
    
    return [JJAppDelegateModule getModulesWithkey:@"ApplicationWillTerminateModules"];
}



// ------------------------
JJROUTER_EXTERN_METHOD(JJAppDelegateModule, setApplicationWillChangeStatusBarFrameModules, arg, callback) {
    [JJAppDelegateModule setModules:arg[JJRouterParamsOption] key:@"ApplicationWillChangeStatusBarFrameModules"];
    return nil;
}

JJROUTER_EXTERN_METHOD(JJAppDelegateModule, getApplicationWillChangeStatusBarFrameModules, arg, callback) {
    
    return [JJAppDelegateModule getModulesWithkey:@"ApplicationWillChangeStatusBarFrameModules"];
}







// ------------------------
JJROUTER_EXTERN_METHOD(JJAppDelegateModule, setOpenURLModules, arg, callback) {
    
    [JJAppDelegateModule setModules:arg[JJRouterParamsOption] key:@"OpenURLModules"];
    return nil;
}

JJROUTER_EXTERN_METHOD(JJAppDelegateModule, getOpenURLModules, arg, callback) {
    
    return [JJAppDelegateModule getModulesWithkey:@"OpenURLModules"];
}


JJROUTER_EXTERN_METHOD(JJAppDelegateModule, setApplicationOpenURLOptionsModules, arg, callback) {
    
    [JJAppDelegateModule setModules:arg[JJRouterParamsOption] key:@"ApplicationOpenURLOptionsModules"];
    return nil;
}

JJROUTER_EXTERN_METHOD(JJAppDelegateModule, getApplicationOpenURLOptionsModules, arg, callback) {
    
    return [JJAppDelegateModule getModulesWithkey:@"ApplicationOpenURLOptionsModules"];
}


// ------------------------
JJROUTER_EXTERN_METHOD(JJAppDelegateModule, setWillResignActiveModules, arg, callback) {
    
    [JJAppDelegateModule setModules:arg[JJRouterParamsOption] key:@"WillResignActiveModules"];
    return nil;
}

JJROUTER_EXTERN_METHOD(JJAppDelegateModule, getWillResignActiveModules, arg, callback) {
    
    return [JJAppDelegateModule getModulesWithkey:@"WillResignActiveModules"];
}


// ------------------------
JJROUTER_EXTERN_METHOD(JJAppDelegateModule, setDidReceiveMemoryWarningModules, arg, callback) {
    [JJAppDelegateModule setModules:arg[JJRouterParamsOption] key:@"DidReceiveMemoryWarningModules"];
    return nil;
}

JJROUTER_EXTERN_METHOD(JJAppDelegateModule, getDidReceiveMemoryWarningModules, arg, callback) {
    
    return [JJAppDelegateModule getModulesWithkey:@"DidReceiveMemoryWarningModules"];
}




// ------------------------
JJROUTER_EXTERN_METHOD(JJAppDelegateModule, setDidRegisterUserNotificationSettingsModules, arg, callback) {
    [JJAppDelegateModule setModules:arg[JJRouterParamsOption] key:@"DidRegisterUserNotificationSettingsModules"];
    return nil;
}

JJROUTER_EXTERN_METHOD(JJAppDelegateModule, getDidRegisterUserNotificationSettingsModules, arg, callback) {
    
    return [JJAppDelegateModule getModulesWithkey:@"DidRegisterUserNotificationSettingsModules"];
}



// ------------------------
JJROUTER_EXTERN_METHOD(JJAppDelegateModule, setApplicationHandleOpenURLModules, arg, callback) {
    [JJAppDelegateModule setModules:arg[JJRouterParamsOption] key:@"ApplicationHandleOpenURLModules"];
    return nil;
}

JJROUTER_EXTERN_METHOD(JJAppDelegateModule, getApplicationHandleOpenURLModules, arg, callback) {
    
    return [JJAppDelegateModule getModulesWithkey:@"ApplicationHandleOpenURLModules"];
}






// ------------------------
JJROUTER_EXTERN_METHOD(JJAppDelegateModule, setDidRegisterForRemoteNotificationsWithDeviceTokenModules, arg, callback) {
    [JJAppDelegateModule setModules:arg[JJRouterParamsOption] key:@"DidRegisterForRemoteNotificationsWithDeviceTokenModules"];
    return nil;
}

JJROUTER_EXTERN_METHOD(JJAppDelegateModule, getDidRegisterForRemoteNotificationsWithDeviceTokenModules, arg, callback) {
    
    return [JJAppDelegateModule getModulesWithkey:@"DidRegisterForRemoteNotificationsWithDeviceTokenModules"];
}



// ------------------------
JJROUTER_EXTERN_METHOD(JJAppDelegateModule, setDidFailToRegisterForRemoteNotificationsWithErrorModules, arg, callback) {
    [JJAppDelegateModule setModules:arg[JJRouterParamsOption] key:@"DidFailToRegisterForRemoteNotificationsWithErrorModules"];
    return nil;
}

JJROUTER_EXTERN_METHOD(JJAppDelegateModule, getDidFailToRegisterForRemoteNotificationsWithErrorModules, arg, callback) {
    
    return [JJAppDelegateModule getModulesWithkey:@"DidFailToRegisterForRemoteNotificationsWithErrorModules"];
}



// ------------------------
JJROUTER_EXTERN_METHOD(JJAppDelegateModule, setHandleActionWithIdentifierForRemoteNotificationModules, arg, callback) {
    [JJAppDelegateModule setModules:arg[JJRouterParamsOption] key:@"HandleActionWithIdentifierForRemoteNotificationModules"];
    return nil;
}

JJROUTER_EXTERN_METHOD(JJAppDelegateModule, getHandleActionWithIdentifierForRemoteNotificationModules, arg, callback) {
    
    return [JJAppDelegateModule getModulesWithkey:@"HandleActionWithIdentifierForRemoteNotificationModules"];
}



// ------------------------
JJROUTER_EXTERN_METHOD(JJAppDelegateModule, setHandleActionWithIdentifierForRemoteNotificationWithResponseInfoModules, arg, callback) {
    [JJAppDelegateModule setModules:arg[JJRouterParamsOption] key:@"HandleActionWithIdentifierForRemoteNotificationWithResponseInfoModules"];
    return nil;
}

JJROUTER_EXTERN_METHOD(JJAppDelegateModule, getHandleActionWithIdentifierForRemoteNotificationWithResponseInfoModules, arg, callback) {
    
    return [JJAppDelegateModule getModulesWithkey:@"HandleActionWithIdentifierForRemoteNotificationWithResponseInfoModules"];
}



// ------------------------
JJROUTER_EXTERN_METHOD(JJAppDelegateModule, setHandleActionWithIdentifierForLocalNotificationModules, arg, callback) {
    [JJAppDelegateModule setModules:arg[JJRouterParamsOption] key:@"HandleActionWithIdentifierForLocalNotificationModules"];
    return nil;
}

JJROUTER_EXTERN_METHOD(JJAppDelegateModule, getHandleActionWithIdentifierForLocalNotificationModules, arg, callback) {
    
    return [JJAppDelegateModule getModulesWithkey:@"HandleActionWithIdentifierForLocalNotificationModules"];
}


// ------------------------
JJROUTER_EXTERN_METHOD(JJAppDelegateModule, setHandleActionWithIdentifierForLocalNotificationWithResponseInfoModules, arg, callback) {
    [JJAppDelegateModule setModules:arg[JJRouterParamsOption] key:@"HandleActionWithIdentifierForLocalNotificationWithResponseInfoModules"];
    return nil;
}

JJROUTER_EXTERN_METHOD(JJAppDelegateModule, getHandleActionWithIdentifierForLocalNotificationWithResponseInfoModules, arg, callback) {
    
    return [JJAppDelegateModule getModulesWithkey:@"HandleActionWithIdentifierForLocalNotificationWithResponseInfoModules"];
}


// ------------------------
JJROUTER_EXTERN_METHOD(JJAppDelegateModule, setDidReceiveLocalNotificationModules, arg, callback) {
    [JJAppDelegateModule setModules:arg[JJRouterParamsOption] key:@"DidReceiveLocalNotificationModules"];
    return nil;
}

JJROUTER_EXTERN_METHOD(JJAppDelegateModule, getDidReceiveLocalNotificationModules, arg, callback) {
    
    return [JJAppDelegateModule getModulesWithkey:@"DidReceiveLocalNotificationModules"];
}


// ------------------------
JJROUTER_EXTERN_METHOD(JJAppDelegateModule, setDidReceiveRemoteNotificationModules, arg, callback) {
    [JJAppDelegateModule setModules:arg[JJRouterParamsOption] key:@"DidReceiveRemoteNotificationModules"];
    return nil;
}

JJROUTER_EXTERN_METHOD(JJAppDelegateModule, getDidReceiveRemoteNotificationModules, arg, callback) {
    
    return [JJAppDelegateModule getModulesWithkey:@"DidReceiveRemoteNotificationModules"];
}




// ------------------------
JJROUTER_EXTERN_METHOD(JJAppDelegateModule, setDidReceiveRemoteNotificationFetchCompletionHandlerModules, arg, callback) {
    [JJAppDelegateModule setModules:arg[JJRouterParamsOption] key:@"DidReceiveRemoteNotificationFetchCompletionHandlerModules"];
    return nil;
}

JJROUTER_EXTERN_METHOD(JJAppDelegateModule, getDidReceiveRemoteNotificationFetchCompletionHandlerModules, arg, callback) {
    
    return [JJAppDelegateModule getModulesWithkey:@"DidReceiveRemoteNotificationFetchCompletionHandlerModules"];
}



// ------------------------
JJROUTER_EXTERN_METHOD(JJAppDelegateModule, setUserNotificationCenterWillPresentNotificationModules, arg, callback) {
    [JJAppDelegateModule setModules:arg[JJRouterParamsOption] key:@"UserNotificationCenterWillPresentNotificationModules"];
    return nil;
}

JJROUTER_EXTERN_METHOD(JJAppDelegateModule, getUserNotificationCenterWillPresentNotificationModules, arg, callback) {
    
    return [JJAppDelegateModule getModulesWithkey:@"UserNotificationCenterWillPresentNotificationModules"];
}




// ------------------------
JJROUTER_EXTERN_METHOD(JJAppDelegateModule, setUserNotificationCenterDidReceiveNotificationResponseModules, arg, callback) {
    [JJAppDelegateModule setModules:arg[JJRouterParamsOption] key:@"UserNotificationCenterDidReceiveNotificationResponseModules"];
    return nil;
}

JJROUTER_EXTERN_METHOD(JJAppDelegateModule, getUserNotificationCenterDidReceiveNotificationResponseModules, arg, callback) {
    
    return [JJAppDelegateModule getModulesWithkey:@"UserNotificationCenterDidReceiveNotificationResponseModules"];
}




// ------------------------
JJROUTER_EXTERN_METHOD(JJAppDelegateModule, setApplicationPerformActionForShortcutItemCompletionHandler, arg, callback) {
    [JJAppDelegateModule setModules:arg[JJRouterParamsOption] key:@"ApplicationPerformActionForShortcutItemCompletionHandler"];
    return nil;
}

JJROUTER_EXTERN_METHOD(JJAppDelegateModule, getApplicationPerformActionForShortcutItemCompletionHandler, arg, callback) {
    
    return [JJAppDelegateModule getModulesWithkey:@"ApplicationPerformActionForShortcutItemCompletionHandler"];
}

// ------------------------
JJROUTER_EXTERN_METHOD(JJAppDelegateModule, setSupportedInterfaceOrientationsForWindow, arg, callback) {
    [JJAppDelegateModule setModules:arg[JJRouterParamsOption] key:@"SupportedInterfaceOrientationsForWindow"];
    return nil;
}

JJROUTER_EXTERN_METHOD(JJAppDelegateModule, getSupportedInterfaceOrientationsForWindow, arg, callback) {
    
    return [JJAppDelegateModule getModulesWithkey:@"SupportedInterfaceOrientationsForWindow"];
}

JJROUTER_EXTERN_METHOD(JJAppDelegateModule, setContinueUserActivityModules, arg, callback) {
    [JJAppDelegateModule setModules:arg[JJRouterParamsOption] key:@"ContinueUserActivityModules"];
    return nil;
}

JJROUTER_EXTERN_METHOD(JJAppDelegateModule, getContinueUserActivityModules, arg, callback) {
    
    return [JJAppDelegateModule getModulesWithkey:@"ContinueUserActivityModules"];
}

@end



