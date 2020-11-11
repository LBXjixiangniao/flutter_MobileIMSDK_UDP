import 'package:flutter/material.dart';

import 'mobile_im_sdk_debug_page.dart';

class MobileIMSDKLoginPage extends StatefulWidget {
  @override
  _MobileIMSDKLoginPageState createState() => _MobileIMSDKLoginPageState();
}

class _MobileIMSDKLoginPageState extends State<MobileIMSDKLoginPage> {
  TextEditingController ipController = TextEditingController(text: 'rbcore.52im.net');
  TextEditingController portController = TextEditingController(text: '7901');
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  void login(){
    Navigator.push(context, MaterialPageRoute(builder: (_)=>MobileIMSDKDebugPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MobileIMSDK_UDP Demo登录'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              height: 40,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: ipController,
                      decoration: InputDecoration(
                        hintText: '请输入服务端ip',
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 8,
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 18,
                    child: Text(':'),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: portController,
                      decoration: InputDecoration(
                        hintText: '请输入服务端端口号',
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 8,
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 40,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: accountController,
                      decoration: InputDecoration(
                        hintText: '登陆用户名',
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 8,
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: '登陆密码',
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 8,
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            FlatButton(
              color: Colors.blue,
              minWidth: BoxConstraints.expand().maxWidth,
              onPressed: login,
              child: Text('登陆',style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}
