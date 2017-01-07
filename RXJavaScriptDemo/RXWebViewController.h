//
//  RXWebViewController.h
//  RXJavaScriptDemo
//
//  Created by srx on 2017/1/7.
//  Copyright © 2017年 https://github.com/srxboys. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 ------ 宽 高 定义 ----
 */
#pragma mark ---- 宽 高 定义 --------
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define NavHeight     64
#define TabbarHeight  49


@interface RXWebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, copy) UIWebView * webView;
@property (nonatomic, copy) NSString * link;
@end
