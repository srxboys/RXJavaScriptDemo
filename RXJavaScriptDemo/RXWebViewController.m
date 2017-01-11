//
//  RXWebViewController.m
//  RXJavaScriptDemo
//
//  Created by srx on 2017/1/7.
//  Copyright © 2017年 https://github.com/srxboys. All rights reserved.
//

#import "RXWebViewController.h"

@interface RXWebViewController ()
@property (nonatomic, copy) UITextView * openCodeTextView;
@property (nonatomic, copy) UITextView * endCodeTextView;
@end

@implementation RXWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, ScreenHeight - NavHeight)];
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.scrollView.bounces = NO;
    [self.view addSubview:_webView];
    
    //    self.link = @"http://www.baidu.com";
    //
    //    //加载 web
    //    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.link]]];
    
    
    
    CGFloat halfW = ScreenWidth /2.0;
    CGFloat top = NavHeight + 100;
    UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, top, halfW, 14)];
    label1.font = [UIFont systemFontOfSize:14];
    label1.backgroundColor = [UIColor darkGrayColor];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [UIColor whiteColor];
    label1.text = @"本地 html";
    [self.view addSubview:label1];
    
    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(halfW, top, halfW, 14)];
    label2.font = [UIFont systemFontOfSize:14];
    label2.backgroundColor = [UIColor grayColor];
    label2.textColor = [UIColor whiteColor];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"已经注入js的 html";
    [self.view addSubview:label2];
    top += 14 + 1;
    
    _openCodeTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, top, halfW - 1, ScreenHeight - top)];
    _openCodeTextView.font = [UIFont systemFontOfSize:14];
    _openCodeTextView.backgroundColor = [UIColor darkGrayColor];
    _openCodeTextView.textColor = [UIColor whiteColor];
    _openCodeTextView.editable = NO;
    [self.view addSubview:_openCodeTextView];
    
    _endCodeTextView = [[UITextView alloc] initWithFrame:CGRectMake(halfW + 1, top, halfW - 1, ScreenHeight - top)];
    _endCodeTextView.font = [UIFont systemFontOfSize:14];
    _endCodeTextView.backgroundColor = [UIColor grayColor];
    _endCodeTextView.textColor = [UIColor whiteColor];
    _endCodeTextView.editable = NO;
    [self.view addSubview:_endCodeTextView];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    //开始加载
    NSLog(@"开始加载");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //加载结束
    NSLog(@"加载结束");
    
   _openCodeTextView.text =  [self printHtmlSourceCode];
}

- (void)addJSAlterPrint {
    _endCodeTextView.text = [self printHtmlSourceCode];
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
- (NSString *)printHtmlSourceCode {
    NSString *jsToGetHTMLSource = @"document.getElementsByTagName('html')[0].innerHTML";
    NSString *HTMLSource = [self.webView stringByEvaluatingJavaScriptFromString:jsToGetHTMLSource];
//    NSLog(@"%@",HTMLSource);
    return HTMLSource;
}




- (void) cleanCache {
    //清除UIWebView的缓存//准确的说 是清除请求缓存
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

- (void)cleanCookies {
    //清除 cookies
    NSHTTPCookie * cookie;
    NSHTTPCookieStorage * storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
