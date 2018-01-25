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

#define NAV_VIEW_ADD_RIGHT_BUTTON(__title, __action)  NAV_VIEW_ADD_BAR_BUTTON(self, __title, __action, NO)
#define NAV_VIEW_ADD_LEFT_BUTTON(__title, __action)  NAV_VIEW_ADD_BAR_BUTTON(self, __title, __action, YES)

#define NAV_VIEW_ADD_BAR_BUTTON(__target, __title, __action, __isLeft) \
do { \
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom]; \
    [btn setTitle:__title forState:UIControlStateNormal]; \
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];\
    btn.frame = CGRectMake(0, 0, 80, 70);\
    [btn addTarget:__target action:__action forControlEvents:UIControlEventTouchUpInside]; \
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn]; \
    if(__isLeft) { \
        __target.navigationItem.leftBarButtonItem = item; \
    } \
    else { \
        __target.navigationItem.rightBarButtonItem = item; \
    } \
} while (0)

#define __RX_ADD_JS(str)  @#str
#define __RX_ADD_JSContent(_content) [NSString stringWithFormat:@"var script = document.createElement('script');" \
"script.type = 'text/javascript';" \
"script.text = \"%@\";" \
"document.getElementsByTagName('head')[0].appendChild(script);", _content]



typedef NS_ENUM(NSInteger, HTMLType) {
    HTMLTypeOne,
    HTMLTypeTwo,
    HTMLTypeThree,
    HTMLTypeForth,
    HTMLTypeFive,
    HTMLTypeSix
};


@interface RXWebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, copy) UIWebView * webView;
@property (nonatomic, copy) NSString * link;

- (void)addJSAlterPrint;

/// 设置加载本地哪个html
- (void)settingHtmlLocalCodeWithType:(HTMLType)type;


/*
    有很多代码都重复了，只是为了，更好的理解
    
    能够快速入手
 
 */


/** 清除UIWebView的缓存//准确的说 是清除请求缓存 */
- (void) cleanCache;

/** 清除 cookies */
- (void)cleanCookies;

@end
