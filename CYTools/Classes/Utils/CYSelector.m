//
//  CYSelector.m
//  CYTools
//
//  Created by wsong on 2018/8/20.
//

#import "CYSelector.h"
#import <objc/runtime.h>

@interface CYSelector ()

@property (nonatomic, unsafe_unretained) Class inClass;

@end

@implementation CYSelector

// 获取一个iOS选择器包装对象
+ (instancetype)selector:(SEL)selector
                 inClass:(Class)inClass {
    CYSelector *sel = [[self alloc] init];
    sel.inClass = inClass;
    sel.selector = selector;
    return sel;
}

// 获取带有前缀的选择器
- (SEL)selectorWithPrefix:(NSString *)prefix {
    return NSSelectorFromString([NSString stringWithFormat:@"%@_%@", prefix, _name]);
}

#pragma mark - Setter/Getter
- (void)setSelector:(SEL)selector {
    _selector = selector;
    
    // 获取名称
    _name = NSStringFromSelector(selector);
    
    // 获取参数类型
    Method method = class_getInstanceMethod(_inClass, selector);
    unsigned argumentsCount = method_getNumberOfArguments(method);
    NSMutableArray *parameterTypes = [NSMutableArray arrayWithCapacity:argumentsCount];
    const size_t typesLength = 256;
    char types[typesLength];
    
    for (unsigned index = 0; index < argumentsCount; index++) {
        method_getArgumentType(method, index, types, typesLength);
        [parameterTypes addObject:[NSString stringWithUTF8String:types]];
    }
    _parameterTypes = parameterTypes;
    
    // 获取返回值类型
    method_getReturnType(method, types, typesLength);
    _returnType = [NSString stringWithUTF8String:types];
}

@end
