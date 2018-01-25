//
//  WKWebViewViewController.h
//  RXJavaScriptDemo
//
//  Created by srx on 2017/8/9.
//  Copyright © 2017年 https://github.com/srxboys. All rights reserved.
//

#import "BasicViewController.h"


#define __RX_ADD_JS(str)  @#str

@interface WKWebViewViewController : BasicViewController
@property (nonatomic, copy) NSString * htmlPath;
@property (nonatomic, copy) NSURL * baseURL;
@end
