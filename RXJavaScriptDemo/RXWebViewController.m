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
    
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, ScreenHeight - NavHeight)];
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor lightTextColor];
    self.webView.scrollView.bounces = NO;
    [self.view addSubview:self.webView];
    
    self.link = @"http://www.baidu.com";
    
    //加载 web
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.link]]];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    //开始加载
    NSLog(@"开始加载");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //加载结束
    NSLog(@"加载结束");
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // 加载什么网址
    // 控制 是否让web请求1
    NSLog(@"LoadWithRequest--scheme=%@\nURL=%@\n\n", request.URL.scheme, request.URL.absoluteString);
    return YES;
}




- (NSString *)getHtmlCode {
    NSString * htmlCode = @"";
    /*
    <html>
    <title>HTML</title>
    <style type="text/css">
    <!--
    .STYLE1 {
        font-family: "宋体";
        font-size: 4;
    }
    .body1{text-decoration: underline;}
    -->
    </style>
    </head>
    
    <body>
    <p class="STYLE1"><strong>我</strong>    <em>的</em><strong><font class="body1">第</font></strong><br />一个HTML程序
    </p>
     <input type="submit">tijiao</input>
    </body>
    </html>
     */
    return htmlCode;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
