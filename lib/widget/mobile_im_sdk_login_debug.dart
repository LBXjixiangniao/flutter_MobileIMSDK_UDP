import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MobileIMSDK_UDP Demo登录'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              TextField(),
              Text(':'),
              TextField(),
            ],
          ),
          Row(
            children: [
              TextField(),
              SizedBox(width:8),
              TextField(),
            ],
          ),
        ],
      ),
    );
  }
}
