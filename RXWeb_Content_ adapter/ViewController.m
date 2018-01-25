//
//  ViewController.m
//  RXWeb_Content_ adapter
//
//  Created by srx on 2017/8/8.
//  Copyright © 2017年 https://github.com/srxboys. All rights reserved.
//


#define SYSTEMVERSION   [UIDevice currentDevice].systemVersion

//大于多少版本
#define iOS7OrLater ([SYSTEMVERSION floatValue] >= 7.0)
#define iOS8OrLater ([SYSTEMVERSION floatValue] >= 8.0)
#define iOS9OrLater ([SYSTEMVERSION floatValue] >= 9.0)

#import "ViewController.h"
#import "UIWebViewViewController.h"
#import "WKWebViewViewController.h"

@interface ViewController ()
{
    UIButton * _webViewButton;
    UIButton * _wkWebButton;
    
    NSString * _htmlPath;
    NSURL * _baseURL;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"app 适配 html 高度，图片 宽高";
    
    _webViewButton = [self allocButton];
    [_webViewButton setTitle:@"UIWebView" forState:UIControlStateNormal];
    
    _wkWebButton = [self allocButton];
    [_wkWebButton setTitle:@"WKWebView" forState:UIControlStateNormal];
    
    if(!iOS8OrLater) {
        NSLog(@"当前设备小于iOS8系统，不能用WKWebView");
        _wkWebButton.hidden = YES;
    }
    
    [self.view addSubview:_webViewButton];
    [self.view addSubview:_wkWebButton];
    
    NSString * htmlName = @"HTMLDocument";
    NSString * filePath = [[NSBundle mainBundle] pathForResource:htmlName ofType:@"html"];
    _htmlPath = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];    // 获取当前应用的根目录
    NSString *path = [[NSBundle mainBundle] bundlePath];
    _baseURL = [NSURL fileURLWithPath:path];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat width = 272;
    CGFloat height = 75;
    CGFloat top = 100;
    
    
    CGSize size = [UIApplication sharedApplication].keyWindow.bounds.size;
    CGFloat left = (size.width - width)/2.0;
    _webViewButton.frame = CGRectMake(left, top, width, height);
    top += height + 17;
    _wkWebButton.frame = CGRectMake(left, top, width, height);
}


- (UIButton *)allocButton {
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectZero;
    btn.backgroundColor = [UIColor orangeColor];
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    return btn;
}

- (void)buttonClick:(UIButton *)sender {
    if(sender == _webViewButton) {
        UIWebViewViewController * webViewViewController = [[UIWebViewViewController alloc] init];
        webViewViewController.htmlPath = _htmlPath;
        webViewViewController.baseURL = _baseURL;
        [self.navigationController pushViewController:webViewViewController animated:YES];
    }
    else {
        WKWebViewViewController * webViewViewController = [[WKWebViewViewController alloc] init];
        webViewViewController.htmlPath = _htmlPath;
        webViewViewController.baseURL = _baseURL;
        [self.navigationController pushViewController:webViewViewController animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
