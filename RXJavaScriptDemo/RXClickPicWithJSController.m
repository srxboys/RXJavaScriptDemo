//
//  RXClickPicWithJSController.m
//  RXJavaScriptDemo
//
//  Created by srxboys on 2018/1/25.
//  Copyright © 2018年 https://github.com/srxboys. All rights reserved.
//
/*
    用户点击 h5 图片，进行放大和缩小
 
    1、web 加载后，注入js 给所有图片添加，点击事件 参数就是图片地址
 
    2、js 获取图片地址->下载本地(最好有进度，可以自己写)->放到自定义的UIView里面，然后捏合手势 放大缩小
 */

#import "RXClickPicWithJSController.h"

#import "UIWebView+TS_JavaScriptContext.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface RXClickPicWithJSController ()
{
    JSContext * _jsContext;
}
@end

@implementation RXClickPicWithJSController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingHtmlLocalCodeWithType:HTMLTypeSix];
}

- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext *)ctx {
    __weak typeof(self)weakSelf = self;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//        [self addJavaScript];
//        _jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//        JSValue * app = [_jsContext objectForKeyedSubscript:@"app"];
//        app[@"getImages"] = ^(id obj) {
//            [weakSelf clickPic:obj];
//        };
//
//        NSLog(@"--register-->%zd",[[NSDate date] timeIntervalSince1970]);
        [self addJSAlterPrint];
    });
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [super webViewDidFinishLoad:webView];
    _jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    _jsContext[@"getImages"] = ^(id obj) {
        NSLog(@"%@", obj);
    };
    [self addJavaScript];
    [self addJSAlterPrint];
}

#define __RX_ADD_JS(str)  @#str
#define __RX_ADD_JSContent(_content) [NSString stringWithFormat:@"var script = document.createElement('script');" \
"script.type = 'text/javascript';" \
"script.text = \"%@\";" \
"document.getElementsByTagName('head')[0].appendChild(script);", _content]

- (void)addJavaScript{
    NSString * jsString = __RX_ADD_JS(
        function getImages() {
             var objs = document.getElementsByTagName('img');
             var imgScr = '';
             for(var i=0; i< objs.length; i++){
                 imgScr = imgScr + objs[i].src + '+';
             }
             return imgScr;
        }
    );
    [self.webView stringByEvaluatingJavaScriptFromString:__RX_ADD_JSContent(jsString)];
    NSString * urlResult = [self.webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    //urlResult就是所有图片URL的数组(方便做图片预览功能)
    NSMutableArray * imgArrayM = [[NSMutableArray alloc] initWithArray:[urlResult componentsSeparatedByString:@"+"]];
    [imgArrayM removeLastObject];
    NSLog(@"获取所有的图片地址 imgArray =%@", imgArrayM);
    
    /* 下面的是  给所有图片，添加/更换 onclick事件= 本身图片  告诉我们他点击那个图片 */
    
    //第一种写法
    NSString * jsString2 = __RX_ADD_JS(
        function registerImageClickAction() {
            var imgs = document.getElementsByTagName('img');
            for(var i = 0; i<imgs.length; i++) {
                imgs[i].onclick = function() {
                    window.location.href = 'image-preview:'+ this.src;
                }
            }
        }
   );
     
    /*
    //第二种写法
    NSString * jsString2 = @"function registerImageClickAction(){ \
         var imgs=document.getElementsByTagName('img');\
         for(var i=0;i<imgs.length;i++){\
             imgs[i].onclick = function(){\
                 window.location.href = 'image-preview:' + this.src; \
             }\
         }\
     }";
    */
    [self.webView stringByEvaluatingJavaScriptFromString:__RX_ADD_JSContent(jsString2)];
    [self.webView stringByEvaluatingJavaScriptFromString:@"registerImageClickAction()"];
}


//在这个方法中捕获到图片的点击事件和被点击图片的url (如果所有标签有不为img，还是用这个统一处理吧)
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    //预览图片
    if ([request.URL.scheme isEqualToString:@"image-preview"]) {
        NSString* path = [request.URL.absoluteString substringFromIndex:[@"image-preview:" length]];

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_7_0 || MAC_OS_X_VERSION_MAX_ALLOWED < __MAC_10_9
        path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#else
        path = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
#endif
        [self clickPic:path];
        return NO;
    }
    return YES;
}

- (void)clickPic:(NSString *)urlString {
    
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
