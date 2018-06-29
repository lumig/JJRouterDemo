//
//  JJNotify.m
//  MIGUDEMO
//
//  Created by luming on 2018/6/5.
//  Copyright © 2018年 luming. All rights reserved.
//

#import "JJNotify.h"
#import <objc/runtime.h>
#define kInstanceEventBlockKey @"kInstanceEventBlockKey"

@interface NSObject(JJNotify)
@end

@implementation NSObject(JJNotify)
- (void)setJjNotifyStrategy:(NSMutableDictionary *)jjNotifyStrategy {objc_setAssociatedObject(self, @selector(jjNotifyStrategy), jjNotifyStrategy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);}
- (NSMutableDictionary*)jjNotifyStrategy{return objc_getAssociatedObject(self, _cmd);}
@end


@interface JJNotify()
@property (nonatomic,strong) NSMutableDictionary *notifyDic;

@end
@implementation JJNotify

+ (JJNotify *)sharedInstance {
    static JJNotify *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.notifyDic = [NSMutableDictionary new];
    });
    return instance;
}

+ (void)notify:(nonnull NSString *)eventName info:(nullable id)info {
    NSPointerArray *array=[JJNotify sharedInstance].notifyDic[eventName];
    if(array!=nil){for(id obj in array){
        NotifyBlock block =((NSObject*)obj).jjNotifyStrategy[eventName];
        if(block)block(info);
        
    }
        
    }
}

+ (void)registerNotify:(nonnull NSString *)eventName instance:(nonnull id)instance block:(nullable NotifyBlock)block {
    if([JJNotify sharedInstance].notifyDic[eventName]==nil){[JJNotify sharedInstance].notifyDic[eventName] =  [NSPointerArray weakObjectsPointerArray];}
    NSPointerArray *array=[JJNotify sharedInstance].notifyDic[eventName];
    if(instance==nil){
        return;
        
    }else{
        if(((NSObject*)instance).jjNotifyStrategy==nil){((NSObject*)instance).jjNotifyStrategy = [NSMutableDictionary new];
            
        }
        ((NSObject*)instance).jjNotifyStrategy[eventName] = block==nil?^(id info){}:block;
        [array addPointer:(__bridge void *)instance];
    }
}
@end
