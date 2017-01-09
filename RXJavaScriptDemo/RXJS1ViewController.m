//
//  RXJS1ViewController.m
//  RXJavaScriptDemo
//
//  Created by srx on 2017/1/7.
//  Copyright © 2017年 https://github.com/srxboys. All rights reserved.
//
//iOS 拦截js function

#import "RXJS1ViewController.h"

#import <JavaScriptCore/JavaScriptCore.h>

@interface RXJS1ViewController ()
{
    JSContext * _jsContext;
}
@end

@implementation RXJS1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingHtmlLocalCodeWithType:HTMLTypeOne];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [super webViewDidFinishLoad:webView];
    
    _jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    _jsContext[@"share"] =  ^(id obj){
        NSLog(@"js_result=%@" ,obj);
    };
    
    [self addJSAlterPrint];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
