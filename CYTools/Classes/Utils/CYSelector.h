//
//  CYSelector.h
//  CYTools
//
//  Created by wsong on 2018/8/20.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

/** iOS选择器包装类 */
@interface CYSelector : NSObject

/** iOS选择器  */
@property (nonatomic, assign, readonly) SEL selector;
/** 方法 */
@property (nonatomic, readonly) Method method;
/** 实现 */
@property (nonatomic, readonly) IMP imp;
/** 方法签名 */
@property (nonatomic, readonly) NSMethodSignature *signature;
/** 名称 */
@property (nonatomic, readonly) NSString *name;
/** 参数类型 */
@property (nonatomic, readonly) NSArray<NSString *> *parameterTypes;
/** 返回值类型 */
@property (nonatomic, readonly) NSString *returnType;

/**
 获取一个iOS选择器包装对象
 相同的selector与相同的class，返回的选择器包装对象也相同
 
 @param selector iOS选择器
 @param clazz 选择器所属的类
 @return iOS选择器包装对象
 */
+ (instancetype)selector:(SEL)selector
                 inClass:(Class)clazz;

/**
 解析可变参数列表
 
 @param ap 可变参数列表
 @param type 类型
 @param result 解析结果
 */
+ (void)parseList:(va_list)ap
             type:(const char *)type
           result:(void (^)(id obj, void *originValueAddress))result;

/**
 获取带有前缀的选择器
 
 @return 带有前缀的选择器
 */
- (SEL)selectorWithPrefix:(NSString *)prefix;

@end


