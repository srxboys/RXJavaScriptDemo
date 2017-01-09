//
//  RXJSToHtmlBlockViewController.m
//  RXJavaScriptDemo
//
//  Created by srx on 2017/1/9.
//  Copyright © 2017年 https://github.com/srxboys. All rights reserved.
//
//iOS 往html里注入js,js一旦被调用，就会回调

#import "RXJSToHtmlBlockViewController.h"

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
