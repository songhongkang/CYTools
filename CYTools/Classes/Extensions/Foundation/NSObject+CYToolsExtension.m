//
//  NSObject+CYToolsExtension.m
//  Pods-CYTools_Example
//
//  Created by wsong on 2018/8/20.
//

#import "NSObject+CYToolsExtension.h"
#import <objc/runtime.h>
#import "CYSelector.h"

#pragma mark - Runtime
@implementation NSObject (CYToolsRuntime)

// 交换selector与block
+ (void)cytools_exchangeSelector:(SEL)selector
                           block:(void (^)(id obj, NSArray *parameter))block
                       afterCall:(BOOL)afterCall {
    
    CYSelector *selWrapper = [CYSelector selector:selector inClass:self];
    CYSelector *otherSelWrapper = nil;
    
    if (selWrapper.method) {
        otherSelWrapper = [CYSelector selector:[selWrapper selectorWithPrefix:@"cytools"] inClass:self];
    } else {
        Class superClass = nil;
        while ((superClass = class_getSuperclass(self))) {
            // 找到了方法实现
            if (class_getMethodImplementation(superClass, selector)) {
                otherSelWrapper = [CYSelector selector:selector inClass:superClass];
                break;
            }
        }
    }
    
    class_addMethod(self, otherSelWrapper.selector, imp_implementationWithBlock(^(id obj, ...) {
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:otherSelWrapper.signature];
        
        invocation.target = obj;
        invocation.selector = otherSelWrapper.selector;
        
        NSInteger typesCount = selWrapper.parameterTypes.count;
        NSMutableArray *parameters = [NSMutableArray arrayWithCapacity:typesCount];
        va_list ap;
        va_start(ap, obj);
        
        // i从2开始：直接跳过object与selector
        for (NSInteger i = 2; i < typesCount; i++) {
            [CYSelector parseList:ap
                             type:selWrapper.parameterTypes[i].UTF8String
                           result:^(id obj, void *originValueAddress) {
                               [parameters addObject:obj];
                               [invocation setArgument:originValueAddress
                                               atIndex:i];
                           }];
        }
        va_end(ap);
        
        if (block) {
            if (afterCall) {
                [invocation invoke];
                block(obj, parameters);
            } else {
                block(obj, parameters);
                [invocation invoke];
            }
        }
        
    }), method_getTypeEncoding(selWrapper.method));
    
    method_exchangeImplementations(selWrapper.method, otherSelWrapper.method);
}

@end
