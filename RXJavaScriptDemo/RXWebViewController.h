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

typedef NS_ENUM(NSInteger, HTMLType) {
    HTMLTypeOne,
    HTMLTypeTwo,
    HTMLTypeThree,
    HTMLTypeForth
};


@interface RXWebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, copy) UIWebView * webView;
@property (nonatomic, copy) NSString * link;

/// 设置加载本地哪个html
- (void)settingHtmlLocalCodeWithType:(HTMLType)type;

/// 显示html 源码
- (void)printHtmlSourceCode;


/*
    有很多代码都重复了，只是为了，更好的理解
    
    能够快速入手
 
 */

@end
