//
//  ViewController.m
//  RXJavaScriptDemo
//
//  Created by srx on 2017/1/7.
//  Copyright © 2017年 https://github.com/srxboys. All rights reserved.
//

#define SYSTEMVERSION   [UIDevice currentDevice].systemVersion

//大于多少版本
#define iOS7OrLater ([SYSTEMVERSION floatValue] >= 7.0)
#define iOS8OrLater ([SYSTEMVERSION floatValue] >= 8.0)
#define iOS9OrLater ([SYSTEMVERSION floatValue] >= 9.0)

#import "ViewController.h"

#import "RXJS1ViewController.h"
#import "RXRequstHtmlViewController.h"
#import "RXJSToHtmlViewController.h"
#import "RXJSToHtmlBlockViewController.h"
#import "RXWXWebJSViewController.h"
#import "RXWebRequestViewController.h"

#import "RXClickPicWithJSController.h"

@interface ViewController ()

///iOS 拦截js function
@property (weak, nonatomic) IBOutlet UIButton *interceptJSButton;
- (IBAction)interceptJSButtonClick:(id)sender;

///iOS 代理获取webView的href(html click)
@property (weak, nonatomic) IBOutlet UIButton *htmlDelegateButton;
- (IBAction)htmlDelegateButtonClick:(id)sender;

///iOS 往html里注入js,再去截取方法的调用
@property (weak, nonatomic) IBOutlet UIButton *addJSAndInterceptButton;
- (IBAction)addJSAndInterceptButton:(id)sender;

///iOS 往html里注入js,js一旦被调用，就会回调
@property (weak, nonatomic) IBOutlet UIButton *addJSAndBlockButton;
- (IBAction)addJSAndBlockButtonClick:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *wkwebJSButton;
- (IBAction)wkwebJSButtonClick:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setButtonTitleFrame:_interceptJSButton];
    [self setButtonTitleFrame:_htmlDelegateButton];
    [self setButtonTitleFrame:_addJSAndInterceptButton];
    [self setButtonTitleFrame:_addJSAndBlockButton];
    if(!iOS8OrLater) {
        NSLog(@"当前设备小于iOS8系统，不能用WKWebView");
        _wkwebJSButton.hidden = YES;
    }
    
}

- (void)setButtonTitleFrame:(UIButton *)btn {
    btn.titleLabel.numberOfLines = 0;
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#define RXClass(vc_class) [vc_class class]

- (void)push:(Class)className {
    UIViewController * vc = [className new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)interceptJSButtonClick:(id)sender {
    [self push:RXClass(RXJS1ViewController)];
}

- (IBAction)htmlDelegateButtonClick:(id)sender {
    [self push:RXClass(RXRequstHtmlViewController)];
}

- (IBAction)addJSAndInterceptButton:(id)sender {
    [self push:RXClass(RXJSToHtmlViewController)];
}

- (IBAction)addJSAndBlockButtonClick:(id)sender {
    [self push:RXClass(RXJSToHtmlBlockViewController)];
}

- (IBAction)wkwebJSButtonClick:(id)sender {
//    RXWXWebJSViewController * five = [[RXWXWebJSViewController alloc] init];
//    RXWebRequestViewController * webdd = [[RXWebRequestViewController alloc] init];
    
//    [self push:RXClass(RXWebRequestViewController)];
//    [self push:RXClass(RXWXWebJSViewController)];
    [self push:RXClass(RXClickPicWithJSController)];
}

@end
