# Modifications by Nick #
* 全面支持 ARC. so iOS 5.
* 去掉了 JSONKit 的依赖, 改用水果家自己的 JSON 解析
* 去掉了 ASIHttpRequest 的依赖, 改用 AFNetworking 作为网络模块

# WeiboSDK #
新浪微博SDK，基于v2版API接口，对认证和请求进行了封装，

## 静态库引用SDK实例 ##
SDK应用示例(静态库引用)，包含最新微博列表、多帐号管理、发布文字微博、发布图片微博等功能示例。
静态库引用SDK的安装方式请见：[sample](https://github.com/JimLiu/WeiboSDK/tree/master/sample "新浪微博SDK示例") 。

## 非静态库引用SDK实例 ##
SDK应用示例(非静态库引用，代码引用)，包含最新微博列表、多帐号管理、发布文字微博、发布图片微博等功能示例。
非静态库安装方式请见：[sample_nolib](https://github.com/JimLiu/WeiboSDK/tree/master/sample_nolib "新浪微博SDK示例") 。


##API参考文档##
关于API的完整文档请参考：[新浪微博API文档](http://open.weibo.com/wiki/%E9%A6%96%E9%A1%B5 "新浪微博API文档") 。

##第三方类库##
### AFNetworking ###
[AFNetworking](https://github.com/AFNetworking/AFNetworking "ASIHttpRequest官方网站") A delightful iOS and OS X networking framework.
###MBProgressHUD###
[MBProgressHUD](https://github.com/jdg/MBProgressHUD "MBProgressHUD 官方网站") 是一个漂亮的Loading对话框类库，在一些需要提示Loading的消息框使用它来显示。


##截图##
####首页####
![首页](https://github.com/JimLiu/WeiboSDK/blob/master/screenshots/Home.png?raw=true)

####帐号管理####
![帐号管理](https://github.com/JimLiu/WeiboSDK/blob/master/screenshots/Accounts.png?raw=true)

####撰写微博####
![撰写微博](https://github.com/JimLiu/WeiboSDK/blob/master/screenshots/Compose.png?raw=true)