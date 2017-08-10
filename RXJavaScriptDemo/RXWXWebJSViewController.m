//
//  RXWXWebJSViewController.m
//  RXJavaScriptDemo
//
//  Created by srx on 2017/2/10.
//  Copyright © 2017年 https://github.com/srxboys. All rights reserved.
//

/*
 ------ 宽 高 定义 ----
 */
#pragma mark ---- 宽 高 定义 --------
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define NavHeight     64
#define TabbarHeight  49

#import "RXWXWebJSViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface RXWXWebJSViewController ()<WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>
{
    WKWebView * _webView;
    JSContext * _jsContext;
}
@end

@implementation RXWXWebJSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"try 请求网址前 注入js";
    [self configUI];
}

- (void)configUI {
    
  
    
    //js代码
//    NSString *js = @"var script = document.createElement('script');"
//    "%@"
//    "script.text = \" var app = {}; app.%@ = function() {};\";"
//    //定义myFunction方法
//    "document.getElementsByTagName('head')[0].appendChild(script);";
    
    NSString * scriptId = @"script.id = 'injectionJSEND';";
    NSString * functionName = @"jumpPage";
    
    NSString * js = [NSString stringWithFormat:@"var script = document.createElement('script');"
                           "%@"
                           "script.text = \"var app = {}; app.%@ = function() {};  app.share =function() {};\";"
                           //定义myFunction方法
                           "document.getElementsByTagName('head')[0].appendChild(script);", scriptId,   functionName];
    
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
    WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [config.userContentController addUserScript:script];
    
    // 注入JS对象名称`share`，当JS通过`share`来调用时，
    // 我们可以在WKScriptMessageHandler代理中接收到
    [config.userContentController addScriptMessageHandler:self name:@"loadHtml"];
    [config.userContentController addScriptMessageHandler:self name:@"share"];
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, ScreenHeight - NavHeight) configuration:config];
    _webView.opaque = NO;
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.scrollView.bounces = NO;
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"RXWXWebHtml" ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];    // 获取当前应用的根目录
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    // 通过baseURL的方式加载的HTML
    // 可以在HTML内通过相对目录的方式加载js,css,img等文件
    [_webView loadHTMLString:htmlCont baseURL:baseURL];
    
}

//页面跳转的代理方法：
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"didReceiveServerRedirectForProvisionalNavigation=");
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    NSLog(@"decidePolicyForNavigationResponse=");
    decisionHandler(WKNavigationResponsePolicyAllow);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"decidePolicyForNavigationAction");
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"didFinishNavigation");
    
    // 显示html 源码
    [self printWebSouceCode];
//
    
    
//    _jsContext = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    //定义好JS要调用的方法, share就是调用的share方法名
//    [_webView evaluateJavaScript:@"documentView.webView.mainFrame.javaScriptContext" completionHandler:^(id _Nullable object, NSError * _Nullable error) {
//        NSLog(@"object=%@", object);
//    }];
    
//    [self interceptJSFunction];
}

//拦截js方法
- (void)interceptJSFunction {
    //获取 app变量的share方法
    //    weak(weakSelf);
    JSValue * app = [_jsContext objectForKeyedSubscript:@"app"];
    app[@"share"] = ^(id obj){
        NSLog(@"share %@", obj);
    };
    app[@"jumpPage"] = ^(id className, id jsonString) {
        NSLog(@"jumpPage %@=%@", className, jsonString);
    };
    app[@"sendSession"] = ^(id sessionId) {
        NSString *string = [NSString stringWithFormat:@"%@",sessionId];
        NSLog(@"sendSession %@", sessionId);
    };
}

#pragma mark - WKScriptMessageHandler
///[config.userContentController addScriptMessageHandler:self name:@"share"];
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"share"]) {
        // 打印所传过来的参数，只支持NSNumber, NSString, NSDate, NSArray,
        // NSDictionary, and NSNull类型
        NSLog(@"do share ——> body=%@\n", message.body);
    }
    else if ([message.name isEqualToString:@"loadHtml"]) {
        // 当请求网址时就获取js
        NSLog(@"\nloadHtml=\n%@", message.body);
    }
    
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
}


- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"\n alert========= \n");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    NSLog(@"\n ConfirmPanelWithMessage========= \n");
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    NSLog(@"\n TextInputPanel========= \n");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
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
