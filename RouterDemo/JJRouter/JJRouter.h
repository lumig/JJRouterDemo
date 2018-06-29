//
//  JJRouter.h
//  JJKit
//
//  Created by luming on 2018/6/6.
//  Copyright © 2018年 luming. All rights reserved.
//


#ifndef JJROUTER
#define JJROUTER

#import <Foundation/Foundation.h>


// 错误信息域
extern  NSString *const __nonnull JJRouterErrorDomain;

// arg 字典key
extern  NSString *const __nonnull JJRouterParamsOption;


// 处理调用完过程回调，可传任意oc对象
typedef void (^JJRouterCompletion)( id __nullable object);

/*
 输出方demo:
 JJROUTER_EXTERN_METHODX(JJProductModule, showProduct, arg, callback) {
 
    // do something
    return @"abc";
 }
 */
// 组件对外公开接口, m组件名, i接口名, p(arg)接收参数, c(callback)回调block
#define JJROUTER_EXTERN_METHOD(m,i,p,c) + (id) routerHandle_##m##_##i:(NSDictionary*)arg callback:(JJRouterCompletion)callback




// -------------------------------
/**
 *
 *  路由控制器
 *
 *  功能：解耦业务逻辑
 *  组件业务A与业务B之间不能有相互的引用，不可以直接调用，调用必须通过路由控制器调用完成
 */
@interface JJRouter : NSObject




/**
 *  @author steven, 16-09-12 18:10:30
 *
 *  组件通信（输入方）
 *
 *  参数规则:  URL中query与arg拼装出完整参数, query可不填，遵循URI get 参数规则, arg可为nil
 *
 *  @return 任意oc对象
 *
 *  @param urlString        - Scheme的URL,如 router://MyJJ/userInfo?uid=123, 通过url query传入的参数获取为字典类型
 *
 *  @param arg              - arg 为任意oc对象, nil. 注意:如果arg为字典类型，
 拼装结果要优先于query中相同字段(query中相同字段会被替换), 不为字典类型query有参数时以key为JJRouterParamsOption获取
 *
 *  @param error            - error 通信过程异常
 *
 *  @param completion       - completion 通信完后相应的callback, 业务输出方自行维护该block
 *
 */



+ (nullable id)openURL:(nonnull NSString *)urlString arg:(nullable id)arg error:( NSError*__nullable *__nullable)error completion:(nullable JJRouterCompletion)completion;



@end

#endif
