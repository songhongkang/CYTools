//
//  CYSelector.h
//  CYTools
//
//  Created by wsong on 2018/8/20.
//

#import <Foundation/Foundation.h>

/** iOS选择器包装类 */
@interface CYSelector : NSObject

/** iOS选择器 */
@property (nonatomic, assign, readonly) SEL selector;
/** 名称 */
@property (nonatomic, copy, readonly) NSString *name;
/** 参数类型 */
@property (nonatomic, strong, readonly) NSArray<NSString *> *parameterTypes;
/** 返回值类型 */
@property (nonatomic, copy, readonly) NSString *returnType;

/**
 获取一个iOS选择器包装对象
 相同的selector与相同的class，返回的选择器包装对象也相同
 
 @param selector iOS选择器
 @param inClass 选择器所属的类
 @return iOS选择器包装对象
 */
+ (instancetype)selector:(SEL)selector
                 inClass:(Class)inClass;

/**
 获取带有前缀的选择器

 @return 带有前缀的选择器
 */
- (SEL)selectorWithPrefix:(NSString *)prefix;

@end


