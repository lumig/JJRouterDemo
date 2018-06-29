//
//  UIView+JJModule.m
//  JJKit
//
//  Created by luming on 2018/6/5.
//  Copyright © 2018年 luming. All rights reserved.
//

#import "UIView+JJModule.h"
#import <objc/runtime.h>
@implementation UIView (JJModule)

- (void)setJj_moduleUserInfo:(id)jj_moduleUserInfo
{
    objc_setAssociatedObject(self, @selector(jj_moduleUserInfo), jj_moduleUserInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)jj_moduleUserInfo
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setJj_moduleCallbackBlock:(JJModuleCallbackBlock)jj_moduleCallbackBlock
{
    objc_setAssociatedObject(self, @selector(jj_moduleCallbackBlock), jj_moduleCallbackBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (JJModuleCallbackBlock)jj_moduleCallbackBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

@end
