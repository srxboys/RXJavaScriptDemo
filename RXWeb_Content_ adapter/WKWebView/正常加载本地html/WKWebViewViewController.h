//
//  WKWebViewViewController.h
//  RXJavaScriptDemo
//
//  Created by srx on 2017/8/9.
//  Copyright © 2017年 https://github.com/srxboys. All rights reserved.
//

#import "BasicViewController.h"


#define __RX_ADD_JS(str)  @#str

#define __RX_ADD_JSContent(_content) [NSString stringWithFormat:@"var script = document.createElement('script');" \
"script.type = 'text/javascript';" \
"script.text = \"%@\";" \
"document.getElementsByTagName('head')[0].appendChild(script);", _content]

@interface WKWebViewViewController : BasicViewController
@property (nonatomic, copy) NSString * htmlPath;
@property (nonatomic, copy) NSURL * baseURL;
@end
