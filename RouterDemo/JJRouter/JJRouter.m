//
//  JJRouter.h
//  JJKit
//
//  Created by luming on 2018/6/6.
//  Copyright © 2018年 luming. All rights reserved.
//

#import "JJRouter.h"
#import "RouterMsgSend.h"


#import <objc/runtime.h>
#import <objc/message.h>

//#define JJROUTER_EXTERN_METHOD(m,i,p,c) id routerHandle_##m##_##i(NSDictionary *arg, JJRouterCompletion callback)



NSString* const JJRouterErrorDomain = @"JJRouterErrorDomain";
NSString* const JJRouterParamsOption = @"JJRouterParamsOption";





static NSString *prefix = @"routerHandle";

static NSString *JJRouterENCodeURL      = @"__JJRouterENCodeURL";
static NSString *JJRouterScheme         = @"__JJRouterScheme";
static NSString *JJRouterModule         = @"__JJRouterModule";
static NSString *JJRouterAction         = @"__JJRouterAction";
static NSString *JJRouterQuery          = @"__JJRouterQuery";
static NSString *JJRouterSymbol         = @"__JJRouterSymbol";
static NSString *JJRouterFuncSymbol     = @"__JJRouterFuncSymbol";



@interface JJRouter ()
{
}

@property (nonatomic, nonnull, strong) NSMutableDictionary *routerBlocks;

@end



@implementation JJRouter



+ (instancetype)sharedInstance
{
    static JJRouter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
    });
    return instance;
}



- (NSMutableDictionary *)routerBlocks
{
    if (!_routerBlocks) {
        _routerBlocks = [[NSMutableDictionary alloc] init];
    }
    return _routerBlocks;
}






static void rt_generateError(NSString *errorInfo, NSError **error){
    
    NSLog(@"%@", errorInfo);

    if (error) {
        *error = [NSError errorWithDomain:JJRouterErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey:errorInfo}];
    }
}





#define SPECIAL_CHARACTER @"!*'();:@&=+$,/?%#[]"
+ (NSString*)escapeURIComponent:(NSString*)src {
//    return src;
//    if (src == nil)
//        return nil;
    
    
    //utf-8转化成unicode
    return [src stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
//    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
//                                                                                                    (CFStringRef)src,
//                                                                                                    NULL,
//                                                                                                    (CFStringRef)SPECIAL_CHARACTER,
//                                                                                                    kCFStringEncodingUTF8 ));
//    
//    return encodedString;
}

/**
 将unicode转化成utf-8
 
 @param enStr unicodeString
 @return utf-8
 */
+ (NSString*) unescapeURIComponent:(NSString*)enStr {
    
    return [enStr stringByRemovingPercentEncoding];

//    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
//                                                                                                             (CFStringRef)enStr,
//                                                                                                             CFSTR(""),
//                                                                                                             kCFStringEncodingUTF8));
//    return result;
}


- (NSString *)decodQuery:(NSString *)str {
    
    NSMutableString *targetParamsStr = [NSMutableString string];
    NSArray* paramStringArr = [str componentsSeparatedByString:@"&"];
    for (int i = 0; i < [paramStringArr count]; i++) {
        
        NSString* paramString = paramStringArr[i];
        NSArray* paramArr = [paramString componentsSeparatedByString:@"="];
        if (paramArr.count > 1) {
            NSString* k = [paramArr objectAtIndex:0];
            NSString* v = [paramArr objectAtIndex:1];
            if ( i == 0 )
            {
                [targetParamsStr appendFormat:@"%@=%@", k, [JJRouter unescapeURIComponent:v]];
            }
            else
            {
                [targetParamsStr appendFormat:@"&%@=%@", k, [JJRouter unescapeURIComponent:v]];
            }
        }
    }
    return targetParamsStr;
}

- (NSURL *) encodeUrl:(NSString *)url {
    
    if ([url rangeOfString:@"://"].location != NSNotFound) {
        
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        NSMutableString *targetParamsStr = [NSMutableString string];

        
        NSArray* pathInfo = [url componentsSeparatedByString:@"?"];
        if (pathInfo.count > 1) {
            
            [targetParamsStr appendFormat:@"%@?", pathInfo[0]];

            //
            NSString* parametersString = [pathInfo objectAtIndex:1];
            NSArray* paramStringArr = [parametersString componentsSeparatedByString:@"&"];
            for (NSString* paramString in paramStringArr) {
                NSArray* paramArr = [paramString componentsSeparatedByString:@"="];
                if (paramArr.count > 1) {
                    NSString* key = [paramArr objectAtIndex:0];
                    NSString* value = [paramArr objectAtIndex:1];
                    parameters[key] = value;
                }
            }
        }
        

        NSArray *keys = [parameters allKeys];
        NSUInteger i, c = [keys count];
        for (i = 0; i < c; i++)
        {
            NSString *k=[keys objectAtIndex:i];
            NSString *v = [parameters objectForKey:k];
            if ( i == 0 )
            {
                [targetParamsStr appendFormat:@"%@=%@", k, [JJRouter escapeURIComponent:v]];
            }
            else
            {
                [targetParamsStr appendFormat:@"&%@=%@", k, [JJRouter escapeURIComponent:v]];
            }
            
        }
        
        return [NSURL URLWithString:targetParamsStr];
        
    }
    return nil;
}

//将url解析成需要的字典
- (NSDictionary *) getComponentsFromURL:(NSString*)url {
    
    BOOL encoded = NO;
    
    NSURL *nsUrl = [NSURL URLWithString:url];
    if (!nsUrl) {
        encoded = YES;
        nsUrl = [[JJRouter sharedInstance] encodeUrl:url];
    }
    
    NSString *scheme = [nsUrl scheme];//解析scheme
    NSString *module = [nsUrl host];
    NSString *action = [[nsUrl path] stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    if (action && [action length] && [action hasPrefix:@"_"]) {
        action = [action stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:@""];
    }
    
    
    NSString *query = nil;
    NSArray* pathInfo = [nsUrl.absoluteString componentsSeparatedByString:@"?"];
    if (pathInfo.count > 1) {
        query = [pathInfo objectAtIndex:1];
    }
    
    
//    NSString *query = [nsUrl query];
    NSMutableDictionary *coms = [NSMutableDictionary dictionary];
    
    
    if ( nsUrl ) {
        coms[JJRouterENCodeURL] = nsUrl.absoluteString;
    }
    if ( scheme && [scheme length] ) {
        coms[JJRouterScheme] = scheme;
    }
    if ( module && [module length] ) {
        coms[JJRouterModule] = module;
    }
    if ( action && [action length] ) {
        coms[JJRouterAction] = action;
    }
    if ( query && [query length] ) {
        coms[JJRouterQuery] = query;
        // added by yanggnag 2017-07-09
        // 如果原始url参数不能初始化NSURL，为了兼容错误，encodeUrl方法中做了解码处理，这里要进行被编过码的query需要解码处理
        if (encoded)
        {
            coms[JJRouterQuery] = [[JJRouter sharedInstance] decodQuery:query];
        }
    }
    
    
    NSString *symbol = [NSString stringWithFormat:@"%@_%@", module, action];
    coms[JJRouterSymbol] = symbol;
    coms[JJRouterFuncSymbol] = [NSString stringWithFormat:@"%@_%@", prefix, symbol];

    
    return coms;
}


- (NSMutableDictionary *)extractParametersFromURL:(NSString *)url {
    NSDictionary* pathComponents = [self getComponentsFromURL:url];

    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    if (pathComponents) {
        //添加字典，在相同key的情况下，相对应的value会被赋予新值
        [parameters addEntriesFromDictionary:pathComponents];
    }

    
    return parameters;
}




- (NSDictionary *) extractParamsFromQuery:(NSString *)query {
    
    NSMutableDictionary *parameters = nil;
    NSString *parametersString = query;
    NSArray *paramStringArr = [parametersString componentsSeparatedByString:@"&"];
    if (paramStringArr && [paramStringArr count]>0) {
        parameters = [NSMutableDictionary dictionary];
        for (NSString* paramString in paramStringArr) {
            NSArray *paramArr = [paramString componentsSeparatedByString:@"="];
            if (paramArr.count > 1) {
                NSString *key = [paramArr objectAtIndex:0];
                NSString *value = [paramArr objectAtIndex:1];
                parameters[key] = [JJRouter unescapeURIComponent:value];
            }
        }
    }
    return parameters;
}






// url Query 与方法中传参组合
- (id) composeParams:(NSDictionary *)queryParams attachParams:(id)attachParams {
    if (!queryParams && !attachParams) return nil;
    
    NSMutableDictionary *resultParams = [NSMutableDictionary dictionary];
    if (queryParams && [queryParams isKindOfClass:[NSDictionary class]]) {
        [resultParams addEntriesFromDictionary:queryParams];
    }
    if (attachParams && [attachParams isKindOfClass:[NSDictionary class]]) {
        [resultParams addEntriesFromDictionary:attachParams];
    } else if (attachParams) {
        [resultParams setObject:attachParams forKey:JJRouterParamsOption];
    }
    return resultParams;
}





+ (nullable id)openURL:(nonnull NSString *)urlString arg:(nullable id)arg error:( NSError*__nullable *__nullable)error completion:(nullable JJRouterCompletion)completion {
    
    NSError *err = nil;
    id result = nil;
    
    //将url解析成定义好的字典
    NSMutableDictionary *parameters = [[self sharedInstance] extractParametersFromURL:urlString];
    
    NSString *scheme = parameters[JJRouterScheme];
    NSString *moduleName = parameters[JJRouterModule];
    NSString *action = parameters[JJRouterAction];
    NSString *symbol = parameters[JJRouterSymbol];
    NSString *funcSymbol = parameters[JJRouterFuncSymbol];
    NSString *url = urlString;
    
    // 提取出query中的参数,只要value
    NSDictionary *queryParams = [[self sharedInstance] extractParamsFromQuery: parameters[JJRouterQuery] ];

    
    // 拼装query参数和手动传入参数
    id finalArg = [[self sharedInstance] composeParams:queryParams attachParams:arg];

    
    NSArray *args = finalArg ? @[finalArg] : @[rt_nilObj()];
    
    if (completion) {
        args = @[args[0], completion];
    } else {
        
        // 保持 JJROUTER_EXTERN_METHOD 函数参数对应，防止崩溃
        JJRouterCompletion tempBlock = ^(id result) {};
        args = @[args[0], tempBlock];
    }
    
    Class cls = NSClassFromString(moduleName);

    // routerHandle_##m##_##i:(NSDictionary*)arg callback:(JJRouterCompletion)callback
    NSString *finalAction = [NSString stringWithFormat:@"%@:callback:", funcSymbol];
    //调用方法
    SEL sel = NSSelectorFromString(finalAction);
    if (!cls) {
        
        NSString *eStr = [NSString stringWithFormat:@"*%@组件不存在, 请检查调用的url:%@", moduleName, url];
        rt_generateError(eStr, &err);
        
    } else if (!sel) {
        
        NSString *eStr = [NSString stringWithFormat:@"*%@组件%@方法调用错误, 请检查调用的url:%@", moduleName, action, url];
        rt_generateError(eStr, &err);
        
    } else if (![cls respondsToSelector:sel]) {
        
        NSString *eStr = [NSString stringWithFormat:@"*%@组件没有实现%@方法, 请检查调用的url:%@", moduleName, action, url];
        rt_generateError(eStr, &err);
        
    } else {
        //发消息
        result = [cls RTCallSelectorWithArgArray:sel arg:args error:&err];

    }
    
    
    if (error) {
        *error = err;
    }
    
    return result;
}




@end
