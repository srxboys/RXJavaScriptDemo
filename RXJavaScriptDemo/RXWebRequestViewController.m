//
//  RXWebRequestViewController.m
//  RXJavaScriptDemo
//
//  Created by srx on 2017/6/20.
//  Copyright © 2017年 https://github.com/srxboys. All rights reserved.
//

#import "RXWebRequestViewController.h"

#pragma mark ---- 宽 高 定义 --------
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define NavHeight     64

@interface RXWebRequestViewController ()<UIWebViewDelegate>

@property (nonatomic, copy) UIWebView * webView;

@end

@implementation RXWebRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, ScreenHeight - NavHeight)];
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.scrollView.bounces = NO;
    [self.view addSubview:_webView];
    
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:[self getCookie]];
    
    NSURL * url = [NSURL URLWithString:@"https://www.baidu.com"];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    //开始加载
    NSLog(@"开始加载");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //加载结束
    NSLog(@"加载结束");
    [self printCookies];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"加载失败:%@", error.description);
    [self printCookies];
}

- (void)printCookies {
    NSArray * cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
    if(cookies.count == 0) {
        NSLog(@"\n没有cookies啊\n");
    }
    NSHTTPCookie * cookie = nil;
    for (id enmu_cookie in cookies) {
        if([enmu_cookie isKindOfClass:[NSHTTPCookie class]]) {
            cookie = (NSHTTPCookie *)enmu_cookie;
            NSLog(@"cookie %@: %@", cookie.name, cookie.value);
        }
    }
}


- (NSHTTPCookie *)getCookie {
    NSDictionary * cookieDict = @{NSHTTPCookieVersion:@(1.0),
                                  NSHTTPCookieName:@"srxboys",
                                  NSHTTPCookieValue : @"123456",
                                  NSHTTPCookieDomain:@"1",
                                  NSHTTPCookiePath:@"1"};
    NSHTTPCookie * cookie = [[NSHTTPCookie alloc] initWithProperties:cookieDict];
    return cookie;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
