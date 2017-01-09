# RXJavaScriptDemo

## iOS app的webView 与 js 交互
> #import <JavaScriptCore/JavaScriptCore.h>

-
```obj
<html>
    <head>
        <script> var message = "您获取的字符串为nil,哈哈";</script>
        <title>iOS 拦截js function</title>
        <script type="text/javascript">
            function share(var varCharInfo) {
                //其实iOS已经拦截，就不会走下面的alert
                alert("该提示框是通过 onload 事件调用的。" + varCharInfo)
            }
        </script>
    </head>

    <body>
        <br><br><br><br><br><br>
        <button onclick="share(message)"> 调用js方法 </button>
    </body>
</html>
````

```obj
<html>
    <head>
        <script> var message = "iOS 往html里注入js,再去截取方法的调用";</script>
        <title>iOS 拦截js function</title>
        <!-- 这里是没有js方法的-->
        <!-- 需要app 去注入-->
    </head>

    <body>
        <br><br><br><br><br><br>
        <button onclick="share(message)"> 调用js方法 </button>
    </body>
</html>
````



# 界面
![srxboys_JS](https://github.com/srxboys/RXJavaScriptDemo/blob/master/GIF/iOS_js.gif)

-

如果你有想说的可以 [issues I](https://github.com/srxboys/RXJavaScriptDemo/issues) 。

:sweat_smile::sweat_smile::sweat_smile::sweat_smile::sweat_smile:

-
[表情网站](http://www.emoji-cheat-sheet.com/)
