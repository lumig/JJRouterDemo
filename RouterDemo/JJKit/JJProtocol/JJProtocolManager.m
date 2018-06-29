//
//  JJProtocolManager.m
//  JJKit
//
//  Created by luming on 2018/6/5.
//  Copyright © 2018年 luming. All rights reserved.
//

#import "JJProtocolManager.h"

@interface JJProtocolManager()

@property (nonatomic, strong) NSMutableDictionary *moduleProviderSource;

@end

@implementation JJProtocolManager

+ (JJProtocolManager *)shareInstance
{
    static JJProtocolManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _moduleProviderSource = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (void)registerModuleProvider:(id)provider forProtocol:(Protocol *)protocol
{
    if (provider !=nil && protocol !=nil) {
        [self shareInstance].moduleProviderSource[NSStringFromProtocol(protocol)] = provider;
    }
}

+ (id)moduleProviderForProtocol:(Protocol *)protocol
{
    if (protocol !=nil) {
      return [self shareInstance].moduleProviderSource[NSStringFromProtocol(protocol)];
    }
    return nil;
}
@end
