//
//  NSObject+JJModel.h
//  JJKit
//
//  Created by luming on 2018/6/5.
//  Copyright © 2018年 luming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (JJModel)
- (BOOL)jj_boolValue;

- (NSInteger)jj_integerValue;

- (CGFloat)jj_floatValue;

@property (nonatomic, strong) id jjOriginData;
@end
