//
//  UIWebViewViewController.m
//  RXJavaScriptDemo
//
//  Created by srx on 2017/8/9.
//  Copyright © 2017年 https://github.com/srxboys. All rights reserved.
//

#define SYSTEMVERSION   [UIDevice currentDevice].systemVersion

//大于多少版本
#define iOS7OrLater ([SYSTEMVERSION floatValue] >= 7.0)
#define iOS8OrLater ([SYSTEMVERSION floatValue] >= 8.0)
#define iOS9OrLater ([SYSTEMVERSION floatValue] >= 9.0)

#import "UIWebViewViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface UIWebViewViewController ()<UIWebViewDelegate>
{
    UIWebView * _webView;
    
    JSContext * _jsContext;
}
@end

@implementation UIWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"UIWebView适配";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.scrollView.bounces = NO;
    [self.view addSubview:_webView];
    // 通过baseURL的方式加载的HTML
    // 可以在HTML内通过相对目录的方式加载js,css,img等文件
    [_webView loadHTMLString:self.htmlPath baseURL:self.baseURL];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navigationHeight = self.navigationController.navigationBar.bounds.size.height;
    CGFloat navHeight = statusHeight + navigationHeight;
    
    CGSize size = [UIApplication sharedApplication].keyWindow.bounds.size;
    _webView.frame = CGRectMake(0, navHeight, size.width, size.height - navHeight);

    if(iOS9OrLater) {
        
    }
    
    if(_jsContext) {
        [self imgAutoFit];
    }
   
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // 将要加载什么网址
    // 控制 是否让web请求1
    NSLog(@"LoadWithRequest--scheme=%@\nURL=%@\n\n", request.URL.scheme, request.URL.absoluteString);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    //开始加载
    NSLog(@"开始加载");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //加载结束
    NSLog(@"加载结束");
    
     _jsContext = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    [self imgAutoFit];
}

//html 中图片 适配
- (void)imgAutoFit {
    NSString *js=@"var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function ResizeImages() { "
        "var myimg,oldwidth;"
        "var maxwidth = %f;"
        "for(i=0;i <document.images.length;i++){"
            "myimg = document.images[i];"
            "if(myimg.width != maxwidth){"
               "oldwidth = myimg.width;"
               "myimg.width = %f;"
            "}"
        "}"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    js=[NSString stringWithFormat:js,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width-15];
    [_webView stringByEvaluatingJavaScriptFromString:js];
    [_webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
