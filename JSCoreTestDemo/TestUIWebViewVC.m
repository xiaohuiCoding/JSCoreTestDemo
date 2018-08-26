//
//  TestUIWebViewVC.m
//  JSCoreTestDemo
//
//  Created by xiaohui on 2018/8/26.
//  Copyright © 2018年 xx. All rights reserved.
//

#import "TestUIWebViewVC.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface TestUIWebViewVC ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, weak) JSContext *context;

@end

@implementation TestUIWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpWebView];
}

- (void)setUpWebView {
    _webView = [[UIWebView alloc]init];
    _webView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/2);
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Test" ofType:@"html"];
    NSURL *url = [[NSURL alloc]initFileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2, 200, 50);
    btn1.backgroundColor = [UIColor blackColor];
    [btn1 setTitle:@"OC调用JS无参方法" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(function1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2+100, 200, 50);
    btn2.backgroundColor = [UIColor blackColor];
    [btn2 setTitle:@"OC调用JS有参方法" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(function2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"开始响应请求");
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"开始加载网页");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"网页加载完毕");
    
    _context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    //JS调用OC无参方法
    _context[@"callOCMethod1"] = ^(){
        [self methodWithoutArg];
    };
    
    //JS调用OC有参方法
    _context[@"callOCMethod2"] = ^(){
        NSArray *argArray = [JSContext currentArguments];
        NSString *arg1 = argArray[0];
        NSString *arg2 = argArray[1];
        [self methodWithArgs:arg1 arg2:arg2];
    };
    
    //另外，还可以在这里直接执行JS代码
//    NSString *alertJS = @"alert('successful')"; //js代码
//    [context evaluateScript:alertJS];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"网页加载出错");
}

#pragma mark - OC调用JS方法

- (void)function1 {
    [_webView stringByEvaluatingJavaScriptFromString:@"func1()"];
}

- (void)function2 {
    NSString *arg1 = @"Hello";
    NSString *arg2 = @"world";
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"func2('%@','%@');",arg1,arg2]];
}

#pragma mark - 供JS调用的方法

- (void)methodWithoutArg {
    NSLog(@"JS调用了OC的无参方法");
}

- (void)methodWithArgs:(NSString *)arg1 arg2:(NSString *)arg2 {
    NSLog(@"JS调用了OC的有参方法，参数分别是：%@、%@",arg1,arg2);
}

@end
