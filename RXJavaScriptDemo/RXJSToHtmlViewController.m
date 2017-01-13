//
//  RXJSToHtmlViewController.m
//  RXJavaScriptDemo
//
//  Created by srx on 2017/1/7.
//  Copyright © 2017年 https://github.com/srxboys. All rights reserved.
//
//iOS 往html里注入js,再去截取方法的调用

//参考 apple文档

#import "RXJSToHtmlViewController.h"

#import <JavaScriptCore/JavaScriptCore.h>

@interface RXJSToHtmlViewController ()
{
    JSContext * _jsContext;
}
@end

@implementation RXJSToHtmlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingHtmlLocalCodeWithType:HTMLTypeThree];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [super webViewDidFinishLoad:webView];
    
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
    NSData *data = [(NSString *)obj dataUsingEncoding:NSUTF8StringEncoding ];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //上面是对json的处理
    
    
    //对象、变量的 处理
    NSLog(@"obj=%@", obj);
    
    //看html 给你什么类型了
}

- (void)addJavaScriptName:(NSString *)functionName {
    
    NSString * jsString = [NSString stringWithFormat:@"var script = document.createElement('script');"
                           "script.type = 'text/javascript';"
                           "script.text = \"var app = {}; app.%@ = function() {};\";"
                           //定义myFunction方法
                           "document.getElementsByTagName('head')[0].appendChild(script);", functionName];
    
    [self.webView stringByEvaluatingJavaScriptFromString:jsString];
    
    //iOS app 去掉用js html里的js方法(一般不用)
//    NSString * jsFunction = [NSString stringWithFormat:@"%@();", functionName];
//    [self.webView stringByEvaluatingJavaScriptFromString:jsFunction];
}


//---------------------------
//---------------------------
//---------------------------
//这个和本页面无关
//1、如果你的app html设计到统计，已进入(self.webView loadReques..)，就需要app马上接收..值
//        我会在js 注入<js标签 id = "injectionJSEND"> 告诉html我注入完了，发给我要的值吧！
//2、然后在用上面的 拦截js方法就好了
/**
 *  注入js
 *  @param functionName    注入的方法名
 *  @param isLastInjection 是否是最后注入，并注入id ，告诉html我注入完毕
 */
- (void)addJavaScriptName:(NSString *)functionName isLastInjection:(BOOL)isLastInjection {
    
    NSString * scriptId = @"";
    if(isLastInjection) {
        scriptId = @"script.id = 'injectionJSEND';";
    }
    
    NSString * jsString = [NSString stringWithFormat:@"var script = document.createElement('script');"
                           "%@"
                           "script.text = \"app.%@ = function() {};\";"
                           //定义myFunction方法
                           "document.getElementsByTagName('head')[0].appendChild(script);", scriptId,   functionName];
    [self.webView stringByEvaluatingJavaScriptFromString:jsString];
    
    //iOS app 去掉用js html里的js方法(一般不用)
    //    NSString * jsFunction = [NSString stringWithFormat:@"%@();", functionName];
    //    [self.webView stringByEvaluatingJavaScriptFromString:jsFunction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
