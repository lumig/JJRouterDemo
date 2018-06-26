//
//  RouterMsgSend.h
//  JJKit
//
//  Created by luming on 2018/6/6.
//  Copyright © 2018年 luming. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (RouterMsgSend)

+ (id)RTCallSelector:(SEL)selector error:(NSError *__autoreleasing *)error,...;

+ (id)RTCallSelectorName:(NSString *)selName error:(NSError *__autoreleasing *)error,...;

- (id)RTCallSelector:(SEL)selector error:(NSError *__autoreleasing *)error,...;

- (id)RTCallSelectorName:(NSString *)selName error:(NSError *__autoreleasing *)error,...;

//add by 王建平
- (id)RTCallSelectorWithArgArray:(SEL)selector arg:(NSArray *)arg error:(NSError *__autoreleasing *)error;

FOUNDATION_EXPORT  NSArray *rt_targetBoxingArguments(va_list argList, Class cls, SEL selector, NSError *__autoreleasing *error);


// steven
FOUNDATION_EXPORT  id rt_nilObj();

@end

@interface NSString (RouterMsgSend)

- (id)RTCallClassSelector:(SEL)selector error:(NSError *__autoreleasing *)error,...;

- (id)RTCallClassSelectorName:(NSString *)selName error:(NSError *__autoreleasing *)error,...;

- (id)RTCallClassAllocInitSelector:(SEL)selector error:(NSError *__autoreleasing *)error,...;

- (id)RTCallClassAllocInitSelectorName:(NSString *)selName error:(NSError *__autoreleasing *)error,...;

@end
