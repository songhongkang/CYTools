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

@interface CYViewController ()

@end

@implementation CYViewController

+ (void)load {
    [self cytools_exchangeSelector:@selector(run:::)
                             block:^(NSArray *parameter) {
                                 NSLog(@"%@", parameter);
                             } afterCall:YES];
}

+ (void)run:(NSString *)test :(NSString *)num :(NSInteger)num1 {
    NSLog(@"run - %@ - %@ - %zd", test, num, num1);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.class run:@"3" :@"a" :4];
}

@end
