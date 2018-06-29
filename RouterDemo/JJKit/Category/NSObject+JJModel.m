//
//  NSObject+JJModel.m
//  JJKit
//
//  Created by luming on 2018/6/5.
//  Copyright © 2018年 luming. All rights reserved.
//

#import "NSObject+JJModel.h"
#import <objc/runtime.h>

@implementation NSObject (JJModel)
- (BOOL)jj_boolValue {
    if ([self isKindOfClass:[NSString class]]) {
        if ([((NSString *)self) isEqualToString:@"0"]) {
            return NO;
        }else {
            return YES;
        }
    }else{
        return NO;
    }
}

- (NSInteger)jj_integerValue {
    if ([self isKindOfClass:[NSString class]]) {
        return [((NSString *)self) integerValue];
    }else{
        return 0;
    }
}

- (CGFloat)jj_floatValue {
    if ([self isKindOfClass:[NSString class]]) {
        return [((NSString *)self) floatValue];
    }else{
        return 0;
    }
}

-(id)jjOriginData{
    return objc_getAssociatedObject(self, _cmd);;
}

-(void)setJjOriginData:(id)jjOriginData{
    objc_setAssociatedObject(self, @selector(jjOriginData), jjOriginData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
