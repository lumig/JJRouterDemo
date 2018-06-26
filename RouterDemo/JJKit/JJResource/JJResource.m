//
//  JJResource.m
//  JJKit
//
//  Created by luming on 2018/6/5.
//  Copyright © 2018年 luming. All rights reserved.
//

#import "JJResource.h"
#import <YYKit.h>

@implementation JJResource

+ (YYMemoryCache *)imageCache {
    static YYMemoryCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [YYMemoryCache new];
        cache.shouldRemoveAllObjectsOnMemoryWarning = NO;
        cache.shouldRemoveAllObjectsWhenEnteringBackground = NO;
        cache.name = @"JJResource_ImageCache";
    });
    return cache;
}

+ (UIImage *)imageNamed:(NSString *)name {
    return [self imageNamed:name bundleName:NSStringFromClass(self)];
}

+ (UIImage *)imageNamed:(NSString *)name bundleName:(NSString *)bundleName {
    if (name.length==0) return nil;
    name = [name stringByReplacingOccurrencesOfString:@"@1x.png" withString:@""];
    name = [name stringByReplacingOccurrencesOfString:@"@2x.png" withString:@""];
    name = [name stringByReplacingOccurrencesOfString:@"@3x.png" withString:@""];
    name = [name stringByReplacingOccurrencesOfString:@".png" withString:@""];
    if(bundleName.length==0) return nil;
    bundleName = [bundleName stringByReplacingOccurrencesOfString:@".bundle" withString:@""];
    UIImage *image = [[self imageCache] objectForKey:[self keyWithBundleName:bundleName imageName:name]];
    if (image) return image;
    NSString *ext = name.pathExtension;
    if (ext.length == 0) ext = @"png";
    NSString *path = [[self bundle:bundleName] pathForScaledResource:name ofType:ext];
    if (!path) return nil;
    image = [UIImage imageWithContentsOfFile:path];
    image = [image imageByDecoded];
    if (!image) return nil;
    [[self imageCache] setObject:image forKey:[self keyWithBundleName:bundleName imageName:name]];
    return image;
}

+ (NSBundle *)bundle:(NSString *)bundleName {
    if(bundleName.length==0){
        bundleName = NSStringFromClass(self);
    }
    static NSMutableDictionary *bundleDic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundleDic = [NSMutableDictionary new];
    });
    if(bundleDic[bundleName]==nil){
        NSString *path = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
        bundleDic[bundleName] = [NSBundle bundleWithPath:path];
    }
    NSBundle *bundle = bundleDic[bundleName];
    return bundle;
}

+ (NSString *)keyWithBundleName:(NSString *)bundleName imageName:(NSString *)imageName {
    if (bundleName==nil || imageName == nil ) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@-%@",bundleName,imageName];
}

@end
