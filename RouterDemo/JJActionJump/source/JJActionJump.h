//
//  MGActionJumpManager.h
//  JJActionJump
//
//  Created by luming on 2018/6/7.
//  Copyright © 2018年 luming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Action.h"
#import "JJKit.h"

@interface JJActionJump : NSObject

+ (nullable NSDictionary *)dicPageID;

+ (nullable id)actionJump:(nonnull NSDictionary *)actionParms;

@end
