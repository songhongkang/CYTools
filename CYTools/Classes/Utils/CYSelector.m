//
//  CYSelector.m
//  CYTools
//
//  Created by wsong on 2018/8/20.
//

#import "CYSelector.h"

/** CYSelector缓存池 */
static NSMutableDictionary<NSString *, CYSelector *> *_selectorPools = nil;

@interface CYSelector ()

@property (nonatomic, unsafe_unretained) Class clazz;

@property (nonatomic, assign) SEL selector;

@end

@implementation CYSelector

+ (void)initialize {
    _selectorPools = [NSMutableDictionary dictionary];
}

// 获取一个iOS选择器包装对象
+ (instancetype)selector:(SEL)selector
                 inClass:(Class)inClass {
    
    NSString *key = [NSString stringWithFormat:@"CYSelector:%p-%@", inClass, NSStringFromSelector(selector)];
    
    if (_selectorPools[key]) {
        return _selectorPools[key];
    } else {
        CYSelector *sel = [[self alloc] init];
        sel.clazz = inClass;
        sel.selector = selector;
        _selectorPools[key] = sel;
        return sel;
    }
}

// 解析可变参数列表
+ (void)parseList:(va_list)ap
             type:(const char *)type
           result:(void (^)(id obj, void *originValueAddress))result {
    
    id obj = nil;
    void *originValueAddress = NULL;
    
    if (strcmp(type, @encode(id)) == 0) {
        obj = va_arg(ap, id);
        originValueAddress = &obj;
    } else if (strcmp(type, @encode(CGPoint)) == 0) {
        CGPoint actual = (CGPoint)va_arg(ap, CGPoint);
        obj = [NSValue value:&actual withObjCType:type];
        originValueAddress = &actual;
    } else if (strcmp(type, @encode(CGSize)) == 0) {
        CGSize actual = (CGSize)va_arg(ap, CGSize);
        obj = [NSValue value:&actual withObjCType:type];
        originValueAddress = &actual;
    } else if (strcmp(type, @encode(UIEdgeInsets)) == 0) {
        UIEdgeInsets actual = (UIEdgeInsets)va_arg(ap, UIEdgeInsets);
        obj = [NSValue value:&actual withObjCType:type];
        originValueAddress = &actual;
    } else if (strcmp(type, @encode(double)) == 0) {
        double value = va_arg(ap, double);
        obj = [NSNumber numberWithDouble:value];
        originValueAddress = &value;
    } else if (strcmp(type, @encode(float)) == 0) {
        float value = va_arg(ap, double);
        obj = [NSNumber numberWithFloat:value];
        originValueAddress = &value;
    } else if (strcmp(type, @encode(int)) == 0) {
        int value = va_arg(ap, int);
        obj = [NSNumber numberWithInt:value];
        originValueAddress = &value;
    } else if (strcmp(type, @encode(long)) == 0) {
        long value = va_arg(ap, long);
        obj = [NSNumber numberWithLong:value];
        originValueAddress = &value;
    } else if (strcmp(type, @encode(long long)) == 0) {
        long long value = va_arg(ap, long long);
        obj = [NSNumber numberWithLongLong:value];
        originValueAddress = &value;
    } else if (strcmp(type, @encode(short)) == 0) {
        short value = va_arg(ap, int);
        obj = [NSNumber numberWithShort:value];
        originValueAddress = &value;
    } else if (strcmp(type, @encode(char)) == 0) {
        char value = va_arg(ap, int);
        obj = [NSNumber numberWithChar:value];
        originValueAddress = &value;
    } else if (strcmp(type, @encode(bool)) == 0) {
        bool value = va_arg(ap, int);
        obj = [NSNumber numberWithBool:value];
        originValueAddress = &value;
    } else if (strcmp(type, @encode(unsigned char)) == 0) {
        unsigned char actual = (unsigned char)va_arg(ap, unsigned int);
        obj = [NSNumber numberWithUnsignedChar:actual];
        originValueAddress = &actual;
    } else if (strcmp(type, @encode(unsigned int)) == 0) {
        unsigned int actual = (unsigned int)va_arg(ap, unsigned int);
        obj = [NSNumber numberWithUnsignedInt:actual];
        originValueAddress = &actual;
    } else if (strcmp(type, @encode(unsigned long)) == 0) {
        unsigned long actual = (unsigned long)va_arg(ap, unsigned long);
        obj = [NSNumber numberWithUnsignedLong:actual];
        originValueAddress = &actual;
    } else if (strcmp(type, @encode(unsigned long long)) == 0) {
        unsigned long long actual = (unsigned long long)va_arg(ap, unsigned long long);
        obj = [NSNumber numberWithUnsignedLongLong:actual];
        originValueAddress = &actual;
    } else if (strcmp(type, @encode(unsigned short)) == 0) {
        unsigned short actual = (unsigned short)va_arg(ap, unsigned int);
        obj = [NSNumber numberWithUnsignedShort:actual];
        originValueAddress = &actual;
    }
    
    if (result) {
        result(obj, originValueAddress);
    }
}

// 获取带有前缀的选择器
- (SEL)selectorWithPrefix:(NSString *)prefix {
    return NSSelectorFromString([NSString stringWithFormat:@"%@_%@", prefix, self.name]);
}

#pragma mark - Setter/Getter
// 方法
- (Method)method {
    // 获取类对象
    Class classObject = objc_getClass(class_getName(self.clazz));
    return class_isMetaClass(self.clazz)? class_getClassMethod(classObject, self.selector) : class_getInstanceMethod(classObject, self.selector);
}
// 实现
- (IMP)imp {
    return class_getMethodImplementation(self.clazz, self.selector);
}
// 方法签名
- (NSMethodSignature *)signature {
    // 获取类对象
    Class classObject = objc_getClass(class_getName(self.clazz));
    return class_isMetaClass(self.clazz)? [classObject methodSignatureForSelector:self.selector] : [classObject instanceMethodSignatureForSelector:self.selector];
}
// 名称
- (NSString *)name {
    return NSStringFromSelector(self.selector);
}

static const size_t typesLength = 256;
// 参数类型
- (NSArray<NSString *> *)parameterTypes {
    
    unsigned argumentsCount = method_getNumberOfArguments(self.method);
    NSMutableArray *parameterTypes = [NSMutableArray arrayWithCapacity:argumentsCount];
    char types[typesLength];
    
    for (unsigned index = 0; index < argumentsCount; index++) {
        method_getArgumentType(self.method, index, types, typesLength);
        [parameterTypes addObject:[NSString stringWithUTF8String:types]];
    }
    return parameterTypes;
}
// 返回值类型
- (NSString *)returnType {
    char types[typesLength];
    method_getReturnType(self.method, types, typesLength);
    return [NSString stringWithUTF8String:types];
}

@end
