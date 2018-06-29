//
//  JJResource.h
//  JJKit
//
//  Created by luming on 2018/6/5.
//  Copyright © 2018年 luming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JJResource : NSObject
+ (UIImage *)imageNamed:(NSString *)name;

+ (UIImage *)imageNamed:(NSString *)name bundleName:(NSString*)bundleName;
@end
