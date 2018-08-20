//
//  CYClass.h
//  CYTools
//
//  Created by wsong on 2018/8/20.
//

#import <Foundation/Foundation.h>

@class CYSelector;

@interface CYClass : NSObject

/** 是否是元类 */
@property (nonatomic, assign, readonly, getter=isMetaClass) BOOL metaClass;

/**
 获取一个iOS类包装对象
 相同的clazz，返回的类包装对象也相同
 
 @param clazz 基本类
 @return 类的包装对象
 */
+ (instancetype)clazz:(Class)clazz;

@end
