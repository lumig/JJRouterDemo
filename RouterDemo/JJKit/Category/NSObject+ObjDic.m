//
//  NSObject+ObjDic.m
//  JJKit
//
//  Created by luming on 2018/6/5.
//  Copyright © 2018年 luming. All rights reserved.
//

#import "NSObject+ObjDic.h"
#import <UIKit/UIKit.h>

@implementation NSObject (ObjDic)
-(NSDictionary *)toDictionary
{
    if ([self isKindOfClass:[NSString class]]) {
        @try {
            NSData *data = [(NSString *)self dataUsingEncoding:NSUTF8StringEncoding];
            /** *
             NSJSONReadingMutableContainers 解析为数组或字典
             NSJSONReadingMutableLeaves 解析为可变字符
             NSJSONReadingAllowFragments 解析为除上面两个以外的格式
             */
            NSError *jsonError;
            NSDictionary *objDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:NSJSONReadingMutableContainers
                                                                            error:&jsonError];
            return objDictionary;
            
        }
        @catch (NSException *exception) {
            NSLog(@"error");
            return nil;
        }
    }
    else
    NSLog(@"self is not string");
    return nil;
}

-(NSArray *)toArray
{
    if ([self isKindOfClass:[NSString class]]) {
        @try {
            NSData *data = [(NSString *)self dataUsingEncoding:NSUTF8StringEncoding];
            /** *
             NSJSONReadingMutableContainers 解析为数组或字典
             NSJSONReadingMutableLeaves 解析为可变字符
             NSJSONReadingAllowFragments 解析为除上面两个以外的格式
             */
            NSError *jsonError;
            NSArray *objArray = [NSJSONSerialization JSONObjectWithData:data
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&jsonError];
            return objArray;
            
        }
        @catch (NSException *exception) {
            NSLog(@"error");
            return nil;
        }
    }
    else
    NSLog(@"self is not string");
    return nil;
}

-(NSString *)urlEncodeFullOnce
{
    if ([self isKindOfClass:[NSString class]]) {
        @try {
            NSString *decodedUrl = [self urlDecodeFullOnce];
            while(![decodedUrl isEqualToString:[decodedUrl urlDecodeFullOnce]]) {
                decodedUrl = [decodedUrl urlDecodeFullOnce];
            }
            //            if([[[UIDevice currentDevice]systemVersion]floatValue] >=9.0)
            //            {
            NSString *encodeUrl = [decodedUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            return encodeUrl;
            //            }else{
            //                NSString*encodedString = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)decodedUrl,NULL,(CFStringRef)@":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~` ",kCFStringEncodingUTF8));
            //                return encodedString;
            //            }
        }
        @catch (NSException *exception) {
            NSLog(@"error");
            return nil;
        }
    }
    else
    NSLog(@"self is not string");
    return nil;
}

-(NSString *)urlDecodeFullOnce
{
    if ([self isKindOfClass:[NSString class]]) {
        @try {
            if([[[UIDevice currentDevice]systemVersion]floatValue] >=9.0)
            {
                NSString *decodedString =  [(NSString *)self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                return decodedString;
                
            }else{
                NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,(__bridge CFStringRef)(NSString *)self,CFSTR(""),        CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
                return decodedString;
            }
        }
        @catch (NSException *exception) {
            NSLog(@"error");
            return nil;
        }
    }
    else
    NSLog(@"self is not string");
    return nil;
}
@end
