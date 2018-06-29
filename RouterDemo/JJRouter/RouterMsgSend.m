//
//  RouterMsgSend.h
//  JJKit
//
//  Created by luming on 2018/6/6.
//  Copyright © 2018年 luming. All rights reserved.
//

#import "RouterMsgSend.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIApplication.h>
#endif


#pragma mark : rt_nilObject

@interface rt_pointer : NSObject

@property (nonatomic) void *pointer;

@end

@implementation rt_pointer

@end

@interface rt_nilObject : NSObject

@end

@implementation rt_nilObject

@end

#pragma mark : static

static NSLock *_vkMethodSignatureLock;
static NSMutableDictionary *_vkMethodSignatureCache;
static rt_nilObject *vknilPointer = nil;


static rt_nilObject *temp_vknilPointer = nil;


id rt_nilObj(){

    if (!temp_vknilPointer) {
        temp_vknilPointer = [[rt_nilObject alloc] init];
    }
    return temp_vknilPointer;
}


static NSString *rt_extractStructName(NSString *typeEncodeString){
    
    NSArray *array = [typeEncodeString componentsSeparatedByString:@"="];
    NSString *typeString = array[0];
    __block int firstVaildIndex = 0;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        char c = [typeEncodeString characterAtIndex:idx];
        if (c=='{'||c=='_') {
            firstVaildIndex++;
        }else{
            *stop = YES;
        }
    }];
    return [typeString substringFromIndex:firstVaildIndex];
}

static NSString *rt_selectorName(SEL selector){
    const char *selNameCstr = sel_getName(selector);
    NSString *selName = [[NSString alloc]initWithUTF8String:selNameCstr];
    return selName;
}

static NSMethodSignature *rt_getMethodSignature(Class cls, SEL selector){
    
    if(!_vkMethodSignatureLock)
        _vkMethodSignatureLock = [[NSLock alloc] init];
    [_vkMethodSignatureLock lock];
    
    if (!_vkMethodSignatureCache) {
        _vkMethodSignatureCache = [[NSMutableDictionary alloc]init];
    }
    if (!_vkMethodSignatureCache[cls]) {
        _vkMethodSignatureCache[(id<NSCopying>)cls] =[[NSMutableDictionary alloc]init];
    }
    NSString *selName = rt_selectorName(selector);
    NSMethodSignature *methodSignature = _vkMethodSignatureCache[cls][selName];
    if (!methodSignature) {
        methodSignature = [cls instanceMethodSignatureForSelector:selector];
        if (methodSignature) {
            _vkMethodSignatureCache[cls][selName] = methodSignature;
        }else
        {
            methodSignature = [cls methodSignatureForSelector:selector];
            if (methodSignature) {
                _vkMethodSignatureCache[cls][selName] = methodSignature;
            }
        }
    }
    [_vkMethodSignatureLock unlock];
    return methodSignature;
}

static void rt_generateError(NSString *errorInfo, NSError **error){
    if (error) {
        *error = [NSError errorWithDomain:errorInfo code:0 userInfo:nil];
    }
}

static id rt_targetCallSelectorWithArgumentError(id target, SEL selector, NSArray *argsArr, NSError *__autoreleasing *error){
    
    
    
    Class cls = [target class];
    NSMethodSignature *methodSignature = rt_getMethodSignature(cls, selector);
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [invocation setTarget:target];
    [invocation setSelector:selector];
    
    //
    if([methodSignature numberOfArguments] -2 != argsArr.count)
    {
        NSString* errorStr = [NSString stringWithFormat:@"参数与方法不匹配 (%@)", NSStringFromSelector(selector)];
        rt_generateError(errorStr,error);
        return nil;
    }
    
    
    NSMutableArray* _markArray;
    
    for (int i = 2; i< [methodSignature numberOfArguments]; i++) {
        const char *argumentType = [methodSignature getArgumentTypeAtIndex:i];
        id valObj = argsArr[i-2];
        switch (argumentType[0]=='r'?argumentType[1]:argumentType[0]) {
            #define RT_CALL_ARG_CASE(_typeString, _type, _selector) \
            case _typeString: {                              \
            _type value = [valObj _selector];                     \
            [invocation setArgument:&value atIndex:i];\
            break; \
            }
                RT_CALL_ARG_CASE('c', char, charValue)
                RT_CALL_ARG_CASE('C', unsigned char, unsignedCharValue)
                RT_CALL_ARG_CASE('s', short, shortValue)
                RT_CALL_ARG_CASE('S', unsigned short, unsignedShortValue)
                RT_CALL_ARG_CASE('i', int, intValue)
                RT_CALL_ARG_CASE('I', unsigned int, unsignedIntValue)
                RT_CALL_ARG_CASE('l', long, longValue)
                RT_CALL_ARG_CASE('L', unsigned long, unsignedLongValue)
                RT_CALL_ARG_CASE('q', long long, longLongValue)
                RT_CALL_ARG_CASE('Q', unsigned long long, unsignedLongLongValue)
                RT_CALL_ARG_CASE('f', float, floatValue)
                RT_CALL_ARG_CASE('d', double, doubleValue)
                RT_CALL_ARG_CASE('B', BOOL, boolValue)

            case ':':{
                NSString *selName = valObj;
                SEL selValue = NSSelectorFromString(selName);
                [invocation setArgument:&selValue atIndex:i];
            }
                break;
            case '{':{
                NSString *typeString = rt_extractStructName([NSString stringWithUTF8String:argumentType]);
                NSValue *val = (NSValue *)valObj;
            #define RT_CALL_ARG_STRUCT(_type, _methodName) \
            if ([typeString rangeOfString:@#_type].location != NSNotFound) {    \
            _type value = [val _methodName];  \
            [invocation setArgument:&value atIndex:i];  \
            break; \
            }
                            RT_CALL_ARG_STRUCT(CGRect, CGRectValue)
                            RT_CALL_ARG_STRUCT(CGPoint, CGPointValue)
                            RT_CALL_ARG_STRUCT(CGSize, CGSizeValue)
                            RT_CALL_ARG_STRUCT(NSRange, rangeValue)
                            RT_CALL_ARG_STRUCT(CGAffineTransform, CGAffineTransformValue)
                            RT_CALL_ARG_STRUCT(UIEdgeInsets, UIEdgeInsetsValue)
                            RT_CALL_ARG_STRUCT(UIOffset, UIOffsetValue)
                            RT_CALL_ARG_STRUCT(CGVector, CGVectorValue)
            }
                break;
            case '*':{
                NSCAssert(NO, @"argument boxing wrong,char* is not supported");
            }
                break;
            case '^':{
                rt_pointer *value = valObj;
                void *pointer = value.pointer;
                id obj = *((__unsafe_unretained id *)pointer);
                if (!obj) {
                    if (argumentType[1] == '@') {
                        if (!_markArray) {
                            _markArray = [[NSMutableArray alloc] init];
                        }
                        [_markArray addObject:valObj];
                    }
                }
                [invocation setArgument:&pointer atIndex:i];
            }
                break;
            case '#':{
                [invocation setArgument:&valObj atIndex:i];
            }
                break;
            default:{
                if ([valObj isKindOfClass:[rt_nilObject class]]) {
                    [invocation setArgument:&vknilPointer atIndex:i];
                }else{
                    [invocation setArgument:&valObj atIndex:i];
                }
            }
        }
    }
    
    [invocation invoke];
    
    if ([_markArray count] > 0) {
        for (rt_pointer *pointerObj in _markArray) {
            void *pointer = pointerObj.pointer;
            id obj = *((__unsafe_unretained id *)pointer);
            if (obj) {
                CFRetain((__bridge CFTypeRef)(obj));
            }
        }
    }
    
    const char *returnType = [methodSignature methodReturnType];
    NSString *selName = rt_selectorName(selector);
    if (strncmp(returnType, "v", 1) != 0 ) {
        if (strncmp(returnType, "@", 1) == 0) {
            void *result;
            [invocation getReturnValue:&result];
            
            if (result == NULL) {
                return nil;
            }
            
            id returnValue;
            if ([selName isEqualToString:@"alloc"] || [selName isEqualToString:@"new"] || [selName isEqualToString:@"copy"] || [selName isEqualToString:@"mutableCopy"]) {
                returnValue = (__bridge_transfer id)result;
            }else{
                returnValue = (__bridge id)result;
            }
            return returnValue;
            
        } else {
            switch (returnType[0] == 'r' ? returnType[1] : returnType[0]) {
                    
            #define RT_CALL_RET_CASE(_typeString, _type) \
            case _typeString: {                              \
            _type returnValue; \
            [invocation getReturnValue:&returnValue];\
            return @(returnValue); \
            break; \
            }
                                RT_CALL_RET_CASE('c', char)
                                RT_CALL_RET_CASE('C', unsigned char)
                                RT_CALL_RET_CASE('s', short)
                                RT_CALL_RET_CASE('S', unsigned short)
                                RT_CALL_RET_CASE('i', int)
                                RT_CALL_RET_CASE('I', unsigned int)
                                RT_CALL_RET_CASE('l', long)
                                RT_CALL_RET_CASE('L', unsigned long)
                                RT_CALL_RET_CASE('q', long long)
                                RT_CALL_RET_CASE('Q', unsigned long long)
                                RT_CALL_RET_CASE('f', float)
                                RT_CALL_RET_CASE('d', double)
                                RT_CALL_RET_CASE('B', BOOL)
                    
                case '{': {
                    NSString *typeString = rt_extractStructName([NSString stringWithUTF8String:returnType]);
                #define RT_CALL_RET_STRUCT(_type) \
                if ([typeString rangeOfString:@#_type].location != NSNotFound) {    \
                _type result;   \
                [invocation getReturnValue:&result];\
                NSValue * returnValue = [NSValue valueWithBytes:&(result) objCType:@encode(_type)];\
                return returnValue;\
                }
                                    RT_CALL_RET_STRUCT(CGRect)
                                    RT_CALL_RET_STRUCT(CGPoint)
                                    RT_CALL_RET_STRUCT(CGSize)
                                    RT_CALL_RET_STRUCT(NSRange)
                                    RT_CALL_RET_STRUCT(CGAffineTransform)
                                    RT_CALL_RET_STRUCT(UIEdgeInsets)
                                    RT_CALL_RET_STRUCT(UIOffset)
                                    RT_CALL_RET_STRUCT(CGVector)
                }
                    break;
                case '*':{
                    
                }
                    break;
                case '^': {
                    
                }
                    break;
                case '#': {
                    
                }
                    break;
            }
            return nil;
        }
    }
    return nil;
};

NSArray *rt_targetBoxingArguments(va_list argList, Class cls, SEL selector, NSError *__autoreleasing *error){
    
    Class class = [cls class];
    NSMethodSignature *methodSignature = rt_getMethodSignature(class, selector);
    NSString *selName = rt_selectorName(selector);
    
    if (!methodSignature) {
        NSString* errorStr = [NSString stringWithFormat:@"unrecognized selector (%@)", selName];
        rt_generateError(errorStr,error);
        return nil;
    }
    
    
    
    NSMutableArray *argumentsBoxingArray = [[NSMutableArray alloc]init];
    
    for (int i = 2; i < [methodSignature numberOfArguments]; i++) {
        const char *argumentType = [methodSignature getArgumentTypeAtIndex:i];
        switch (argumentType[0] == 'r' ? argumentType[1] : argumentType[0]) {
                
        #define RT_BOXING_ARG_CASE(_typeString, _type)\
        case _typeString: {\
        _type value = va_arg(argList, _type);\
        [argumentsBoxingArray addObject:@(value)];\
        break; \
        }\

                        RT_BOXING_ARG_CASE('c', int)
                        RT_BOXING_ARG_CASE('C', int)
                        RT_BOXING_ARG_CASE('s', int)
                        RT_BOXING_ARG_CASE('S', int)
                        RT_BOXING_ARG_CASE('i', int)
                        RT_BOXING_ARG_CASE('I', unsigned int)
                        RT_BOXING_ARG_CASE('l', long)
                        RT_BOXING_ARG_CASE('L', unsigned long)
                        RT_BOXING_ARG_CASE('q', long long)
                        RT_BOXING_ARG_CASE('Q', unsigned long long)
                        RT_BOXING_ARG_CASE('f', double)
                        RT_BOXING_ARG_CASE('d', double)
                        RT_BOXING_ARG_CASE('B', int)
                
            case ':': {
                SEL value = va_arg(argList, SEL);
                NSString *selValueName = NSStringFromSelector(value);
                [argumentsBoxingArray addObject:selValueName];
            }
                break;
            case '{': {
                NSString *typeString = rt_extractStructName([NSString stringWithUTF8String:argumentType]);
                
            #define rt_FWD_ARG_STRUCT(_type, _methodName) \
            if ([typeString rangeOfString:@#_type].location != NSNotFound) {    \
            _type val = va_arg(argList, _type);\
            NSValue* value = [NSValue _methodName:val];\
            [argumentsBoxingArray addObject:value];  \
            break; \
            }
                            rt_FWD_ARG_STRUCT(CGRect, valueWithCGRect)
                            rt_FWD_ARG_STRUCT(CGPoint, valueWithCGPoint)
                            rt_FWD_ARG_STRUCT(CGSize, valueWithCGSize)
                            rt_FWD_ARG_STRUCT(NSRange, valueWithRange)
                            rt_FWD_ARG_STRUCT(CGAffineTransform, valueWithCGAffineTransform)
                            rt_FWD_ARG_STRUCT(UIEdgeInsets, valueWithUIEdgeInsets)
                            rt_FWD_ARG_STRUCT(UIOffset, valueWithUIOffset)
                            rt_FWD_ARG_STRUCT(CGVector, valueWithCGVector)
            }
                break;
            case '*':{
                rt_generateError(@"unsupported char* argumenst",error);
                return nil;
            }
                break;
            case '^': {
                void *value = va_arg(argList, void**);
                rt_pointer *pointerObj = [[rt_pointer alloc]init];
                pointerObj.pointer = value;
                [argumentsBoxingArray addObject:pointerObj];
            }
                break;
            case '#': {
                Class value = va_arg(argList, Class);
                [argumentsBoxingArray addObject:(id)value];
//                rt_generateError(@"unsupported class argumenst",error);
//                return nil;
            }
                break;
            case '@':{
                id value = va_arg(argList, id);
                if (value) {
                    [argumentsBoxingArray addObject:value];
                }else{
                    [argumentsBoxingArray addObject:[rt_nilObject new]];
                }
            }
                break;
            default: {
                rt_generateError(@"unsupported argumenst",error);
                return nil;
            }
        }
    }
    return [argumentsBoxingArray copy];
}

@implementation NSObject (RouterMsgSend)

+ (id)RTCallSelectorName:(NSString *)selName error:(NSError *__autoreleasing *)error,...{
    
    va_list argList;
    va_start(argList, error);
    SEL selector = NSSelectorFromString(selName);
    NSArray *boxingAruments = rt_targetBoxingArguments(argList, [self class], selector, error);
    va_end(argList);
    
    if (!boxingAruments) {
        return nil;
    }
    return rt_targetCallSelectorWithArgumentError(self, selector, boxingAruments, error);
}

+ (id)RTCallSelector:(SEL)selector error:(NSError *__autoreleasing *)error,...{
    
    va_list argList;
    va_start(argList, error);
    NSArray* boxingArguments = rt_targetBoxingArguments(argList, [self class], selector, error);
    va_end(argList);
    
    if (!boxingArguments) {
        return nil;
    }
    return rt_targetCallSelectorWithArgumentError(self, selector, boxingArguments, error);
}

- (id)RTCallSelectorName:(NSString *)selName error:(NSError *__autoreleasing *)error,...{
    
    va_list argList;
    va_start(argList, error);
    SEL selector = NSSelectorFromString(selName);
    NSArray* boxingArguments = rt_targetBoxingArguments(argList, [self class], selector, error);
    va_end(argList);
    
    if (!boxingArguments) {
        return nil;
    }
    return rt_targetCallSelectorWithArgumentError(self, selector, boxingArguments, error);
}

- (id)RTCallSelector:(SEL)selector error:(NSError *__autoreleasing *)error,...{
    
    va_list argList;
    va_start(argList, error);
    NSArray* boxingArguments = rt_targetBoxingArguments(argList, [self class], selector, error);
    va_end(argList);
    
    if (!boxingArguments) {
        return nil;
    }
    
    return rt_targetCallSelectorWithArgumentError(self, selector, boxingArguments, error);
}

//add by 王建平
- (id)RTCallSelectorWithArgArray:(SEL)selector arg:(NSArray *)arg error:(NSError *__autoreleasing *)error{
    

    return rt_targetCallSelectorWithArgumentError(self, selector, arg, error);
}

@end

@implementation NSString (RouterMsgSend)


-(id)RTCallClassSelector:(SEL)selector error:(NSError *__autoreleasing *)error, ...
{
    Class cls = NSClassFromString(self);
    if (!cls) {
        NSString* errorStr = [NSString stringWithFormat:@"unrecognized className (%@)", self];
        rt_generateError(errorStr,error);
        return nil;
    }
    
    va_list argList;
    va_start(argList, error);
    NSArray* boxingArguments = rt_targetBoxingArguments(argList, cls, selector, error);
    va_end(argList);
    
    if (!boxingArguments) {
        return nil;
    }
    
    return rt_targetCallSelectorWithArgumentError(cls, selector, boxingArguments, error);
}


-(id)RTCallClassSelectorName:(NSString *)selName error:(NSError *__autoreleasing *)error, ...
{
    Class cls = NSClassFromString(self);
    if (!cls) {
        NSString* errorStr = [NSString stringWithFormat:@"unrecognized className (%@)", self];
        rt_generateError(errorStr,error);
        return nil;
    }
    
    SEL selector = NSSelectorFromString(selName);
    
    va_list argList;
    va_start(argList, error);
    NSArray* boxingArguments = rt_targetBoxingArguments(argList, cls, selector, error);
    va_end(argList);
    
    if (!boxingArguments) {
        return nil;
    }
    
    return rt_targetCallSelectorWithArgumentError(cls, selector, boxingArguments, error);
}

-(id)RTCallClassAllocInitSelector:(SEL)selector error:(NSError *__autoreleasing *)error, ...
{
    Class cls = NSClassFromString(self);
    if (!cls) {
        NSString* errorStr = [NSString stringWithFormat:@"unrecognized className (%@)", self];
        rt_generateError(errorStr,error);
        return nil;
    }
    
    va_list argList;
    va_start(argList, error);
    NSArray* boxingArguments = rt_targetBoxingArguments(argList, cls, selector, error);
    va_end(argList);
    
    if (!boxingArguments) {
        return nil;
    }
    
    id allocObj = [cls alloc];
    return rt_targetCallSelectorWithArgumentError(allocObj, selector, boxingArguments, error);
}

-(id)RTCallClassAllocInitSelectorName:(NSString *)selName error:(NSError *__autoreleasing *)error, ...
{
    Class cls = NSClassFromString(self);
    if (!cls) {
        NSString* errorStr = [NSString stringWithFormat:@"unrecognized className (%@)", self];
        rt_generateError(errorStr,error);
        return nil;
    }
    
    SEL selector = NSSelectorFromString(selName);
    
    va_list argList;
    va_start(argList, error);
    NSArray* boxingArguments = rt_targetBoxingArguments(argList, cls, selector, error);
    va_end(argList);
    
    if (!boxingArguments) {
        return nil;
    }
    
    id allocObj = [cls alloc];
    return rt_targetCallSelectorWithArgumentError(allocObj, selector, boxingArguments, error);
}

@end

