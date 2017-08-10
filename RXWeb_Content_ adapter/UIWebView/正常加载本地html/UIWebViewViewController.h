//
//  UIWebViewViewController.h
//  RXJavaScriptDemo
//
//  Created by srx on 2017/8/9.
//  Copyright © 2017年 https://github.com/srxboys. All rights reserved.
//

#import "BasicViewController.h"

@interface UIWebViewViewController : BasicViewController
@property (nonatomic, copy) NSString * htmlPath;
@property (nonatomic, copy) NSURL * baseURL;
@end
