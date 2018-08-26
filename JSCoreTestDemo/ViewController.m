//
//  ViewController.m
//  JSCoreTestDemo
//
//  Created by xiaohui on 2018/8/26.
//  Copyright © 2018年 xx. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self testOCCallJS];
//    [self testJSCallOC];
}

- (void)testOCCallJS {
    NSString *jsPath = [[NSBundle mainBundle] pathForResource:@"Test"ofType:@"js"];
    NSString *jsContent = [NSString stringWithContentsOfFile:jsPath encoding:NSUTF8StringEncoding error:nil];
    
    JSContext *context = [[JSContext alloc] init];
    [context evaluateScript:jsContent];
    
    JSValue *value0 = context[@"testBool"];
    JSValue *value1 = context[@"testArray"];
    JSValue *value2 = [context[@"func1"] callWithArguments:nil];
    JSValue *value3 = [context[@"func2"] callWithArguments:@[@"hello",@"world"]];

    NSLog(@"OC获取JS的布尔值：%d",[value0 toBool]);
    NSLog(@"OC获取JS的数组：%@",[value1 toArray]);
    NSLog(@"%@",[value2 toString]);
    NSLog(@"%@",[value3 toString]);
}

- (void)testJSCallOC {
    NSString *jsPath = [[NSBundle mainBundle] pathForResource:@"Test"ofType:@"js"];
    NSString *jsContent = [NSString stringWithContentsOfFile:jsPath encoding:NSUTF8StringEncoding error:nil];
    JSContext *context = [[JSContext alloc] init];
    [context evaluateScript:jsContent];
    
    //JS调用OC无参方法
    context[@"callOCMethod1"] = ^() {
        [self methodWithoutArg];
    };
    [context evaluateScript:@"func3()"];
    
    //JS调用OC有参方法
    context[@"callOCMethod2"] = ^(NSString *arg1, NSString *arg2) {
        [self methodWithArgs:arg1 arg2:arg2];
    };
    [context evaluateScript:@"func4()"];
}

#pragma mark - 供JS调用的方法

- (void)methodWithoutArg {
    NSLog(@"JS调用了OC的无参方法");
}

- (void)methodWithArgs:(NSString *)arg1 arg2:(NSString *)arg2 {
    NSLog(@"JS调用了OC的有参方法，参数分别是：%@、%@",arg1,arg2);
}

@end
