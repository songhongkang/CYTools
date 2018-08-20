//
//  CYViewController.m
//  CYTools
//
//  Created by wsong on 08/20/2018.
//  Copyright (c) 2018 wsong. All rights reserved.
//

#import "CYViewController.h"
#import "NSObject+CYToolsExtension.h"
#import <objc/runtime.h>


@interface CYViewControllerSon : UIViewController

@end

@implementation CYViewControllerSon

- (void)run:(NSInteger)num {
    NSLog(@"父亲");
}

@end

@interface CYViewController : CYViewControllerSon

@end

@implementation CYViewController

+ (void)load {
    // 交换run方法，并且在原方法之后回调
    [self cytools_exchangeSelector:@selector(run:)
                             block:^(id obj, NSArray *parameter) {
                                 NSLog(@"对象：%@， 拦截到的参数为%@", obj, parameter);
                             } afterCall:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self run:3];
}

- (void)run:(NSInteger)num {
    [super run:num];
    NSLog(@"儿子");
}

@end
