//
//  JJActionJumpManager.m
//  JJActionJump
//
//  Created by luming on 2018/6/7.
//  Copyright © 2018年 luming. All rights reserved.
//

#import "JJActionJump.h"
#import "JJRouter.h"
#import "JJActionJumpMacro.h"
#import "JJFunc.h"
@implementation JJActionJump

+ (NSDictionary *)dicPageID {
	static NSDictionary *dicPageID;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		dicPageID = @{
					  JJ_LOGIN :
						  @"router://JJActionService/jjLogin",
                      JJ_WebView:
                          @"router://JJActionService/showWebVC",
                      
					  };
	});
	return dicPageID;
}

+ (NSString *)returnActionModuleURLWithPageID:(NSString *)pageID {
    for (NSString *type in self.dicPageID) {
        if ([type isEqualToString:pageID]) {
            return self.dicPageID[type];
        }
    }
    return nil;
}

+ (nullable id)actionJump:(nonnull NSDictionary *)actionParms {
	NSLog(@"%@",actionParms);
	if(![actionParms isKindOfClass:NSDictionary.class]){
		NSLog(@"🐔🈲 %@ is not a NSDictionary 🐔🈲",actionParms);
		return nil;
	}
	Action *action = actionParms[Jump_Key_Action];
	JJActionJumpCallback completion = actionParms[Jump_Key_Callback];
	//跳转登录
	if ([action.type isEqualToString:JUMP_INNER_NEW_PAGE]) {
		NSString *url = [self returnActionModuleURLWithPageID:action.params.pageID];
		if (url) {
			[JJRouter openURL:url arg:actionParms error:nil completion:completion];
		}
        //跳转至H5页面（用WebView打开）
    }else if ([action.type isEqualToString:JJ_WebView]) {
        [JJRouter openURL:@"router://JJActionService/showWebVC" arg:actionParms error:nil completion:completion];
        
        //跳转至H5页面（用系统浏览器打开）
    } else if ([action.type isEqualToString:JUMP_H5_BY_OS_BROWSER]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:action.params.url]];
        
        //跳转至外部APP
    } else if ([action.type isEqualToString:JUMP_OUTTER_APP]) {
        [JJRouter openURL:@"" arg:actionParms error:nil completion:completion];
        NSLog(@"openURL为空");
        
        //刷新页面
    }
    
	return nil;
}

@end
