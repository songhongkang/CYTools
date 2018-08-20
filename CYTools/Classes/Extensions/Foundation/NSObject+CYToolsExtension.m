//
//  NSObject+CYToolsExtension.m
//  Pods-CYTools_Example
//
//  Created by wsong on 2018/8/20.
//

#import "NSObject+CYToolsExtension.h"
#import <objc/runtime.h>
#import "CYClass.h"
#import "CYSelector.h"

#pragma mark - Runtime
@implementation NSObject (CYToolsRuntime)

void CYBoxValue(va_list ap, const char *encode, void (^result)(id obj, void *originValueAddress)) {
    
    id obj = nil;
    void *originValueAddress = NULL;
    
    if (strcmp(encode, @encode(id)) == 0) {
        obj = va_arg(ap, id);
        originValueAddress = &obj;
    } else if (strcmp(encode, @encode(CGPoint)) == 0) {
        CGPoint actual = (CGPoint)va_arg(ap, CGPoint);
        obj = [NSValue value:&actual withObjCType:encode];
        originValueAddress = &actual;
    } else if (strcmp(encode, @encode(CGSize)) == 0) {
        CGSize actual = (CGSize)va_arg(ap, CGSize);
        obj = [NSValue value:&actual withObjCType:encode];
        originValueAddress = &actual;
    } else if (strcmp(encode, @encode(UIEdgeInsets)) == 0) {
        UIEdgeInsets actual = (UIEdgeInsets)va_arg(ap, UIEdgeInsets);
        obj = [NSValue value:&actual withObjCType:encode];
        originValueAddress = &actual;
    } else if (strcmp(encode, @encode(double)) == 0) {
        double value = va_arg(ap, double);
        obj = [NSNumber numberWithDouble:value];
        originValueAddress = &value;
    } else if (strcmp(encode, @encode(float)) == 0) {
        float value = va_arg(ap, double);
        obj = [NSNumber numberWithFloat:value];
        originValueAddress = &value;
    } else if (strcmp(encode, @encode(int)) == 0) {
        int value = va_arg(ap, int);
        obj = [NSNumber numberWithInt:value];
        originValueAddress = &value;
    } else if (strcmp(encode, @encode(long)) == 0) {
        long value = va_arg(ap, long);
        obj = [NSNumber numberWithLong:value];
        originValueAddress = &value;
    } else if (strcmp(encode, @encode(long long)) == 0) {
        long long value = va_arg(ap, long long);
        obj = [NSNumber numberWithLongLong:value];
        originValueAddress = &value;
    } else if (strcmp(encode, @encode(short)) == 0) {
        short value = va_arg(ap, int);
        obj = [NSNumber numberWithShort:value];
        originValueAddress = &value;
    } else if (strcmp(encode, @encode(char)) == 0) {
        char value = va_arg(ap, int);
        obj = [NSNumber numberWithChar:value];
        originValueAddress = &value;
    } else if (strcmp(encode, @encode(bool)) == 0) {
        bool value = va_arg(ap, int);
        obj = [NSNumber numberWithBool:value];
        originValueAddress = &value;
    } else if (strcmp(encode, @encode(unsigned char)) == 0) {
        unsigned char actual = (unsigned char)va_arg(ap, unsigned int);
        obj = [NSNumber numberWithUnsignedChar:actual];
        originValueAddress = &actual;
    } else if (strcmp(encode, @encode(unsigned int)) == 0) {
        unsigned int actual = (unsigned int)va_arg(ap, unsigned int);
        obj = [NSNumber numberWithUnsignedInt:actual];
        originValueAddress = &actual;
    } else if (strcmp(encode, @encode(unsigned long)) == 0) {
        unsigned long actual = (unsigned long)va_arg(ap, unsigned long);
        obj = [NSNumber numberWithUnsignedLong:actual];
        originValueAddress = &actual;
    } else if (strcmp(encode, @encode(unsigned long long)) == 0) {
        unsigned long long actual = (unsigned long long)va_arg(ap, unsigned long long);
        obj = [NSNumber numberWithUnsignedLongLong:actual];
        originValueAddress = &actual;
    } else if (strcmp(encode, @encode(unsigned short)) == 0) {
        unsigned short actual = (unsigned short)va_arg(ap, unsigned int);
        obj = [NSNumber numberWithUnsignedShort:actual];
        originValueAddress = &actual;
    }
    if (result) {
        result(obj, originValueAddress);
    }
}

// 交换selector与block
+ (void)cytools_exchangeSelector:(SEL)selector
                           block:(void (^)(NSArray *parameter))block
                       afterCall:(BOOL)afterCall {
    
    CYSelector *selWrapper = [CYSelector selector:selector
                                          inClass:self];
    SEL otherSelector = [selWrapper selectorWithPrefix:@"cytools"];
    
    [self cytools_exchangeSelector:selector
                               imp:imp_implementationWithBlock(^(id obj, ...) {
        
        NSMethodSignature *signature = [[obj class] instanceMethodSignatureForSelector:otherSelector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        
        invocation.target = obj;
        invocation.selector = otherSelector;
        
        NSInteger typesCount = selWrapper.parameterTypes.count;
        NSMutableArray *parameters = [NSMutableArray arrayWithCapacity:typesCount];
        va_list ap;
        va_start(ap, obj);
        
        // i从2开始：直接跳过object与selector
        for (NSInteger i = 2; i < typesCount; i++) {
            CYBoxValue(ap, selWrapper.parameterTypes[i].UTF8String, ^(id obj, void *originValueAddress) {
                [parameters addObject:obj];
                [invocation setArgument:originValueAddress
                                atIndex:i];
            });
        }
        va_end(ap);
        
        if (block) {
            if (afterCall) {
                [invocation invoke];
                block(parameters);
            } else {
                block(parameters);
                [invocation invoke];
            }
        }
        
    }) afterCall:afterCall];
}

// 交换selector与selector
+ (void)cytools_exchangeSelector:(SEL)selector
                   otherSelector:(SEL)otherSelector
                       afterCall:(BOOL)afterCall {

    [self cytools_exchangeSelector:selector
                               imp:method_getImplementation(class_getInstanceMethod(self, otherSelector))
                         afterCall:afterCall];
}

// 交换selector与IMP
+ (void)cytools_exchangeSelector:(SEL)selector
                             imp:(IMP)imp
                       afterCall:(BOOL)afterCall {
    
    Method m1 = class_getInstanceMethod(self, selector);
    SEL otherSelector = [[CYSelector selector:selector
                                      inClass:self] selectorWithPrefix:@"cytools"];
    class_addMethod(self, otherSelector, imp, method_getTypeEncoding(m1));
    
    Method m2 = class_getInstanceMethod(self, otherSelector);
    method_exchangeImplementations(m1, m2);
}

@end
