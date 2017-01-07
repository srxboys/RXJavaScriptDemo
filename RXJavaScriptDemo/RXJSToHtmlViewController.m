//
//  RXJSToHtmlViewController.m
//  RXJavaScriptDemo
//
//  Created by srx on 2017/1/7.
//  Copyright © 2017年 https://github.com/srxboys. All rights reserved.
//

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
    // Do any additional setup after loading the view.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    //注入js 方法
    [self addJavaScriptName:@"share"];
    
    //获取 app变量的share方法
    __weak typeof(self)weakSelf = self;
    JSValue * app = [_jsContext objectForKeyedSubscript:@"app"];
    app[@"share"] = ^(id obj){
        [weakSelf webShare:obj];
    };
}

- (void)webShare:(id)obj {
    NSData *data = [(NSString *)obj dataUsingEncoding:NSUTF8StringEncoding ];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    //在根据自己的
}

- (void)addJavaScriptName:(NSString *)functionName {
    
    NSString * jsString = [NSString stringWithFormat:@"var script = document.createElement('script');"
                           "script.type = 'text/javascript';"
                           "script.text = \"var app = {}; %@ = function() {};\";"
                           //定义myFunction方法
                           "document.getElementsByTagName('head')[0].appendChild(script);", functionName];
    NSString * jsFunction = [NSString stringWithFormat:@"%@();", functionName];
    
    [self.webView stringByEvaluatingJavaScriptFromString:jsString];
    [self.webView stringByEvaluatingJavaScriptFromString:jsFunction
     ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
