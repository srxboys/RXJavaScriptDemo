//
//  RXWebViewController.m
//  RXJavaScriptDemo
//
//  Created by srx on 2017/1/7.
//  Copyright © 2017年 https://github.com/srxboys. All rights reserved.
//

#import "RXWebViewController.h"

@interface RXWebViewController ()

@end

@implementation RXWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, ScreenHeight - NavHeight)];
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor lightTextColor];
    _webView.scrollView.bounces = NO;
    [self.view addSubview:_webView];
    
//    self.link = @"http://www.baidu.com";
//    
//    //加载 web
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.link]]];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    //开始加载
    NSLog(@"开始加载");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //加载结束
    NSLog(@"加载结束");
    
    [self printHtmlSourceCode];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"加载失败:%@", error.description);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // 将要加载什么网址
    // 控制 是否让web请求1
    NSLog(@"LoadWithRequest--scheme=%@\nURL=%@\n\n", request.URL.scheme, request.URL.absoluteString);
    return YES;
}

#pragma mark - ~~~~~~~~~~~ /// 设置加载本地哪个html ~~~~~~~~~~~~~~~
- (void)settingHtmlLocalCodeWithType:(HTMLType)type {
    NSString * htmlCode = @"";
    if(type == HTMLTypeOne) {
        htmlCode = @"RXJS1HTML";
    }
    else if(type == HTMLTypeTwo) {
        htmlCode = @"RXRequst";
    }
    else if(type == HTMLTypeThree) {
        htmlCode = @"RXJSToHtml";
    }
    else {
        htmlCode = @"RXJSToHtmlBlock";
    }
    
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:htmlCode ofType:@"html"];NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];    // 获取当前应用的根目录
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    // 通过baseURL的方式加载的HTML
    // 可以在HTML内通过相对目录的方式加载js,css,img等文件
    [_webView loadHTMLString:htmlCont baseURL:baseURL];
}

#pragma mark - ~~~~~~~~~~~ /// 显示html 源码 ~~~~~~~~~~~~~~~
- (void)printHtmlSourceCode {
    NSString *jsToGetHTMLSource = @"document.getElementsByTagName('html')[0].innerHTML";
    NSString *HTMLSource = [self.webView stringByEvaluatingJavaScriptFromString:jsToGetHTMLSource];
    NSLog(@"%@",HTMLSource);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
