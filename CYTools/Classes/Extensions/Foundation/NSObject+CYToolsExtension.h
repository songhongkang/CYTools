//
//  NSObject+CYToolsExtension.h
//  Pods-CYTools_Example
//
//  Created by wsong on 2018/8/20.
//

#import <Foundation/Foundation.h>

#pragma mark - Runtime
@interface NSObject (CYToolsRuntime)

/**
 交换selector与block
 
 @param selector 选择器
 @param block block
 @param afterCall 如为YES，block在原方法之后调用，则反
 */
+ (void)cytools_exchangeSelector:(SEL)selector
                           block:(void (^)(NSArray *parameter))block
                       afterCall:(BOOL)afterCall;

/**
 交换selector与selector
 
 @param selector 选择器
 @param otherSelector 另一个选择器
 @param afterCall 如为YES，otherSelector在原方法之后调用，则反
 */
+ (void)cytools_exchangeSelector:(SEL)selector
                   otherSelector:(SEL)otherSelector
                       afterCall:(BOOL)afterCall;

/**
 交换selector与IMP
 
 @param selector 选择器
 @param imp 另一个函数实现
 @param afterCall 如为YES，otherSelector在原方法之后调用，则反
 */
+ (void)cytools_exchangeSelector:(SEL)selector
                             imp:(IMP)imp
                       afterCall:(BOOL)afterCall;

@end

