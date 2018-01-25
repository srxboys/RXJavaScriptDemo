//
//  RXJSToHtmlBlockViewController.m
//  RXJavaScriptDemo
//
//  Created by srx on 2017/1/9.
//  Copyright © 2017年 https://github.com/srxboys. All rights reserved.
//
//iOS 往html里注入js,js一旦被调用，就会回调

//参考 : https://www.bignerdranch.com/blog/javascriptcore-example/

#import "RXJSToHtmlBlockViewController.h"

#import <JavaScriptCore/JavaScriptCore.h>
#import "UIWebView+TS_JavaScriptContext.h"

@interface RXJSToHtmlBlockViewController ()
{
    JSContext * _jsContext;
}
@end

@implementation RXJSToHtmlBlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingHtmlLocalCodeWithType:HTMLTypeForth];
}

- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext *)ctx {
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self addJavaScriptName:@"londingJS"];
        _jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        JSValue * app = [_jsContext objectForKeyedSubscript:@"app"];
        app[@"londingJS"] = ^(id obj) {
            NSLog(@"londingJS=%@", obj);
        };
        
        NSLog(@"--register-->%zd",[[NSDate date] timeIntervalSince1970]);
        [self addJSAlterPrint];
    });
}

- (void)addJavaScriptName:(NSString *)functionName {
    /*
    NSString * jsString = [NSString stringWithFormat:@"var script = document.createElement('script');"
                           "script.type = 'text/javascript';"
                           "script.text = \"var app = {}; app.%@ = function() {};\";"
                           "document.getElementsByTagName('head')[0].appendChild(script);", functionName];
    
    [self.webView stringByEvaluatingJavaScriptFromString:jsString];
     */
    NSString * jsString2 = __RX_ADD_JS(
                                       var app = {};
                                       app.%@ = function() {};
                                       );
    
    jsString2 = [NSString stringWithFormat:jsString2, functionName];
    [self.webView stringByEvaluatingJavaScriptFromString:__RX_ADD_JSContent(jsString2)];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [super webViewDidFinishLoad:webView];
    NSLog(@"--webViewDidFinishLoad-->%zd",[[NSDate date] timeIntervalSince1970]);
    
    //注入js 方法
    [self addJavaScriptName:@"share"];
    
    _jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    //获取 app变量的share方法
    __weak typeof(self)weakSelf = self;
    JSValue * app = [_jsContext objectForKeyedSubscript:@"app"];
    
    app[@"share"] = ^(id obj){
        [weakSelf webShare:obj];
    };
    
    [self addJSAlterPrint];
}

- (void)webShare:(id)obj {
//    NSData *data = [(NSString *)obj dataUsingEncoding:NSUTF8StringEncoding ];
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //上面是对json的处理
    
    //对象、变量的 处理
    NSLog(@"obj=%@", obj);
    
    //看html 给你什么类型了
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
