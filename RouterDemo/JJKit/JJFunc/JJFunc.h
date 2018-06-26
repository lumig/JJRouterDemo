//
//  JJFunc.h
//  JJActionJump
//
//  Created by luming on 2018/6/7.
//  Copyright © 2018年 luming. All rights reserved.
//


#import <Foundation/Foundation.h>

#define JJ_EVENT_KEY(name) static NSString *const name = @#name;

NS_ASSUME_NONNULL_BEGIN

JJ_EVENT_KEY(Jump_Key_Action)
JJ_EVENT_KEY(Jump_Key_Callback)
JJ_EVENT_KEY(Jump_Key_Param)

typedef void (^JJActionJumpCallback)( id __nullable object);

NS_ASSUME_NONNULL_END

#ifndef ActionJumpReal
#define ActionJumpReal(_action_) \
	if([NSClassFromString(@"JJActionJump") respondsToSelector:NSSelectorFromString(@"actionJump:")]){\
	[NSClassFromString(@"JJActionJump") performSelector:NSSelectorFromString(@"actionJump:") withObject:_action_];\
}
#endif

@interface JJFunc : NSObject

// 处理调用完过程回调，可传任意oc对象
+(nonnull JJActionJumpCallback)callback:(nonnull JJActionJumpCallback)callback;

@end
