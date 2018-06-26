//
//  JJProtocolManager.h
//  JJKit
//
//  Created by luming on 2018/6/5.
//  Copyright © 2018年 luming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJProtocol.h"
@interface JJProtocolManager : NSObject

+ (void)registerModuleProvider:(id)provider forProtocol:(Protocol*)protocol;

+ (id)moduleProviderForProtocol:(Protocol *)protocol;
@end
