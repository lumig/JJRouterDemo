//
//  JJMacro.h
//  JJKit
//
//  Created by luming on 2018/6/5.
//  Copyright © 2018年 luming. All rights reserved.
//

#ifndef JJMacro_h
#define JJMacro_h

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

#define JJScaleValue(value) ((value) * MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)/ 375.f)
#define JJ_IS_IPHONE_X (MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) > 800)

//#define JJClientId [FCUUID uuidForDevice]

#define JJFont(fontName,jjSize) [UIFont fontWithName:fontName size:jjSize]?[UIFont fontWithName:fontName size:jjSize]:[UIFont systemFontOfSize:jjSize]

//performSelector系列方法编译器警告
#define PerformSelectorNoLeakWarning(_func_) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
_func_; \
_Pragma("clang diagnostic pop") \
} while (0)

//方法执行
#define ActionJump(_action_) PerformSelectorNoLeakWarning(ActionJumpReal(_action_));

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6_Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

// iOS系统版本
#define SYSTEM_VERSION    [[[UIDevice currentDevice] systemVersion] doubleValue]
// 标准系统状态栏高度
#define SYS_STATUSBAR_HEIGHT        20
// 热点栏高度
#define HOTSPOT_STATUSBAR_HEIGHT    20
// 工具栏（UINavigationController.UIToolbar）高度
#define TOOLBAR_HEIGHT                 44
// 标签栏（UITabBarController.UITabBar）高度
#define TABBAR_HEIGHT                 49
// 导航栏（UINavigationController.UINavigationBar）高度
#define NAVIGATION_BAR_HEIGHT         44
// STATUS_BAR_HEIGHT=SYS_STATUSBAR_HEIGHT+[HOTSPOT_STATUSBAR_HEIGHT]
#define STATUS_BAR_HEIGHT ([UIApplication sharedApplication].statusBarFrame.size.height > 0 ? [UIApplication sharedApplication].statusBarFrame.size.height : 20)
// 根据STATUS_BAR_HEIGHT判断是否存在热点栏
#define IS_HOTSPOT_CONNECTED (STATUS_BAR_HEIGHT==(SYS_STATUSBAR_HEIGHT+HOTSPOT_STATUSBAR_HEIGHT)?YES:NO)
// 无热点栏时，标准系统状态栏高度+导航栏高度
#define NORMAL_STATUS_AND_NAV_BAR_HEIGHT (SYS_STATUSBAR_HEIGHT+NAVIGATION_BAR_HEIGHT)
// 实时系统状态栏高度+导航栏高度，如有热点栏，其高度包含在STATUS_BAR_HEIGHT中。
#define STATUS_AND_NAV_BAR_HEIGHT (STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT)
// iPhoneX底部安全区域
#define kSafeAreaBottom  (iPhoneX? 34.0f:0)
//键盘高度
#define KEYBOARD_HEIGHT       260.0

#endif /* JJMacro_h */

