# flutter_MobileIMSDK

开源项目[MobileIMSDK](https://github.com/JackJiang2011/MobileIMSDK) 移动端的flutter封装

## 用法

### 初始化sdk
```
/**
 * 初始化SDK
 * 
 * serverIP:服务器ip地址
 * serverPort：服务器端口号
 * appKey：根据社区回答，暂时无用
 * senseMode：KeepAlive心跳问隔.客户端本模式的设定必须要与服务端的模式设制保持一致，否则 可能因参数的不一致而导致IM算法的不匹配，进而出现不可预知的问题。
 * debug：true表示开启MobileIMSDK Debug信息在控制台下的输出，否则关闭。sdk默认为NO
 * 
 * result->{
 * result:bool, //标识接口调用是否成功
*/
FlutterMobileIMSDK.initMobileIMSDK(
              serverIP: '服务端ip', serverPort:服务端端口号 )
          .then((value) {
        if (value.result == true) {
          //初始化成功
        } else {
          //初始化失败
        }
      }).catchError((onError) {
        //初始化失败
      });
```

### 登录
登录前一定要先初始化sdk，设置ip和端口号
```
FlutterMobileIMSDK.login(loginUserId: accountController.text, loginToken: passwordController.text)
              .then((value) {
            if (value.result == false) {
              //登录失败
            }
          }).catchError((onError) {
            //登录失败
          });
```

登录成功由移步回调确定
```
FlutterMobileIMSDK.setMethodCallHandler(handler: (method) {
      if (method is MobileIMSDKLoginSuccess) {
        //登录成功
      } else if (method is MobileIMSDKLoginFail) {
        //登录失败
      }
    });
```

