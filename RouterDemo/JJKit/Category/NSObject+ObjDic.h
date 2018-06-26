//
//  NSObject+ObjDic.h
//  JJKit
//
//  Created by luming on 2018/6/5.
//  Copyright © 2018年 luming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ObjDic)
/** *将JSON string 转化为Dictionary*/
-(NSDictionary *)toDictionary;

/** *将JSON string 转化为Array*/
-(NSArray *)toArray;

/** *将url string 进行编码，且只需编码一次*/
-(NSString *)urlEncodeFullOnce;

/** *将url string 进行解码，且只需编码一次*/
-(NSString *)urlDecodeFullOnce;

@end
