import 'package:flutter/material.dart';
import 'package:flutter_MobileIMSDK/widget/mobile_im_sdk_login_debug.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MobileIMSDKLoginPage(),
    );
  }
}
