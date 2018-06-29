//
//  UIResponder+Event.m
//  JJKit
//
//  Created by luming on 2018/6/5.
//  Copyright © 2018年 luming. All rights reserved.
//

#import "UIResponder+Event.h"
#import <objc/runtime.h>
#define kEventBlockKey @"kEventBlockKey"
#define kNeedNextResponderKey @"kNeedNextResponderKey"

@implementation UIResponder (Event)
- (void)setEventStrategy:(NSMutableDictionary *)eventStrategy {objc_setAssociatedObject(self, @selector(eventStrategy), eventStrategy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);}
- (NSMutableDictionary*)eventStrategy{return objc_getAssociatedObject(self, _cmd);}

- (void)routerEvent:(nonnull NSString *)eventName info:(nullable id)info{
    EventBlock block = self.eventStrategy[eventName][kEventBlockKey];
    if (block)
    block(info);
    if(self.eventStrategy!=nil){if([self.eventStrategy[eventName][kNeedNextResponderKey] isEqual:@(NO)]){return;}}
    [self.nextResponder routerEvent:eventName info:info];
}

- (void)registerEvent:(nonnull NSString *)eventName block:(nullable EventBlock)block next:(BOOL)needNext{
    if(self.eventStrategy==nil){self.eventStrategy = [NSMutableDictionary new];}
    self.eventStrategy[eventName] = @{kEventBlockKey:(block==nil?^(id info){}:block),kNeedNextResponderKey:@(needNext)};
}
@end
