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

@interface RXJSToHtmlBlockViewController ()

@end

@implementation RXJSToHtmlBlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingHtmlLocalCodeWithType:HTMLTypeForth];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
