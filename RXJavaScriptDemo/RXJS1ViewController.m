//
//  RXJS1ViewController.m
//  RXJavaScriptDemo
//
//  Created by srx on 2017/1/7.
//  Copyright © 2017年 https://github.com/srxboys. All rights reserved.
//

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
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    _jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    _jsContext[@"function方法名"] =  ^(id obj){
        NSLog(@"js_result=%@" ,obj);
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
