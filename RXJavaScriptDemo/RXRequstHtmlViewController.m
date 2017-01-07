//
//  RXRequstHtmlViewController.m
//  RXJavaScriptDemo
//
//  Created by srx on 2017/1/7.
//  Copyright © 2017年 https://github.com/srxboys. All rights reserved.
//

#import "RXRequstHtmlViewController.h"

@interface RXRequstHtmlViewController ()

@end

@implementation RXRequstHtmlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    
    NSString *scheme = [request.URL scheme];
    scheme = [scheme lowercaseString];
    //如果网页地址是 https://www.baidu.com  scheme=https
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        //如果是点击的
        NSString *urlString = [NSString stringWithFormat:@"%@",request.URL];
        //跳转到商品详情  //product-123
        if ([urlString rangeOfString:@"product-"].location != NSNotFound) {
            
            NSRange range0 = [urlString rangeOfString:@"product-"];
            NSRange range1 = [urlString rangeOfString:@".html"];
            
            //获取 是否有商品标号
            if (range0.location!=NSNotFound && range1.location!= NSNotFound) {
                //有就跳转
                // ...Controller * xx =......
                // xx.sku = 123;
//                [self.navigationController pushViewController:xx animated:YES];
            }
            return NO;
        }
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end