//
//  WKWebViewViewController.m
//  RXJavaScriptDemo
//
//  Created by srx on 2017/8/9.
//  Copyright © 2017年 https://github.com/srxboys. All rights reserved.
//

#import "WKWebViewViewController.h"
#import <WebKit/WebKit.h>

@interface WKWebViewViewController ()<WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>
{
    WKWebView * _webView;
}
@end

@implementation WKWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"WKWebView适配";
    self.view.backgroundColor = [UIColor whiteColor];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    // 设置偏好设置
    config.preferences = [[WKPreferences alloc]init];
    // 默认为0
    config.preferences.minimumFontSize = 10;
    // 默认认为YES
    config.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    
    //#其实我们没有必要去创建它，因为它根本没有属性和方法：
    // web内容处理池，由于没有属性可以设置，也没有方法可以调用，不用手动创建
    config.processPool = [[WKProcessPool alloc]init];
    
    // 通过JS与webview内容交互
    config.userContentController = [[WKUserContentController alloc]init];
    
    // 根据JS字符串初始化WKUserScript对象
    WKUserScript *getAllImgScript = [[WKUserScript alloc] initWithSource:[self getAllImg] injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [config.userContentController addUserScript:getAllImgScript];
     WKUserScript *setImgOnClickScript = [[WKUserScript alloc] initWithSource:[self setImgOnClick] injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [config.userContentController addUserScript:setImgOnClickScript];
//
//    // 注入JS对象名称`imgReturn`，当JS通过`imgReturn`来调用时，
//    // 我们可以在WKScriptMessageHandler代理中接收到
    [config.userContentController addScriptMessageHandler:self name:@"imgReturn"];

    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    _webView.opaque = NO;
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.scrollView.bounces = NO;
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    
    [_webView loadHTMLString:self.htmlPath baseURL:self.baseURL];
}

- (NSString *)getAllImg {
    //获取所有图片地址
    NSString * getAllImg = __RX_ADD_JS(
                  function getImages() {
                      var objs = document.getElementsByTagName('img');
                      var imgScr = '';
                      for(var i=0; i< objs.length; i++){
                          imgScr = imgScr + objs[i].src + '+';
                      }
                      return imgScr;
                  }
      );
    return getAllImg;
}

- (NSString *)setImgOnClick {
    //给图片添加点击事件
    NSString * setImgOnClick = __RX_ADD_JS(
                   function registerImageClickAction() {
                       var imgs = document.getElementsByTagName('img');
                       for(var i = 0; i<imgs.length; i++) {
                           imgs[i].onclick = function() {
                               window.webkit.messageHandlers.imgReturn.postMessage({body: 'image-preview:'+ this.src});
                               window.location.href = ' '; //由于本身有 <a hrer=‘’>  或者onclick 等等防止app崩溃
                           }
                       }
                   }
                                           
                   registerImageClickAction();
       );
    return setImgOnClick;
}


#pragma mark - ~~~~~~~~~~~ /// 显示html 源码 ~~~~~~~~~~~~~~~
- (void)printWebSouceCode {
    //获取header源码1
    NSString *JsToGetHTMLSource = @"document.getElementsByTagName('html')[0].innerHTML";
    [_webView evaluateJavaScript:JsToGetHTMLSource completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        if(!error) {
            NSLog(@"\n%@\n\n",obj);
        }
        else {
            NSLog(@"printWebSouceCode error=%@", error.description);
        }
    }];
    
    [_webView evaluateJavaScript:@"getImages()" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        if(!error) {
            NSLog(@"\n数组%@\n\n",obj);
        }
        else {
            NSLog(@"printWebSouceCode error=%@", error.description);
        }
    }];
}

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    if([message.name isEqualToString:@"imgReturn"]) {
        NSLog(@"message.body=%@", message.body);
    }
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [self printWebSouceCode];
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
