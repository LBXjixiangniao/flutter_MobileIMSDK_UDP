import 'package:flutter/material.dart';

class MobileIMSDKDebugPage extends StatefulWidget {
  @override
  _MobileIMSDKDebugPageState createState() => _MobileIMSDKDebugPageState();
}

class _MobileIMSDKDebugPageState extends State<MobileIMSDKDebugPage> {
  TextEditingController receiverIdController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  void sendMessage() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(239, 239, 245, 1),
      appBar: AppBar(
        title: Text('MobileIMSDK_UDP Demo'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 12),
              SizedBox(
                height: 50,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('通信状态：通信正常'),
                        Text('当前账号：aa'),
                      ],
                    ),
                    FlatButton(
                      color: Colors.orange,
                      onPressed: () {},
                      child: Text(
                        '退出登陆',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Divider(height: 1),
              ),
              Container(
                height: 40,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: receiverIdController,
                        decoration: InputDecoration(
                          hintText: '接收方的id',
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 8,
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 18,
                    ),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: '发送的消息',
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
              SizedBox(height: 8),
              FlatButton(
                color: Colors.green,
                minWidth: BoxConstraints.expand().maxWidth,
                onPressed: sendMessage,
                child: Text(
                  '发送消息',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Divider(height: 1),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: ListView(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
