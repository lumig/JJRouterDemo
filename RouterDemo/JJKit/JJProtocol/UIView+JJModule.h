//
//  UIView+JJModule.h
//  JJKit
//
//  Created by luming on 2018/6/5.
//  Copyright © 2018年 luming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJBaseProtocol.h"
@interface UIView (JJModule)

@property (nonatomic,strong) id jj_moduleUserInfo;

@property (nonatomic,strong) JJModuleCallbackBlock jj_moduleCallbackBlock;

@end
