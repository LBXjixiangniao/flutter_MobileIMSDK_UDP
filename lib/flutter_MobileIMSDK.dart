import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'method.dart';

class FlutterMobileIMSDKResult {
  bool result;
  dynamic value;

  FlutterMobileIMSDKResult(this.result, this.value);

  FlutterMobileIMSDKResult.fromJson(Map<dynamic, dynamic> json) {
    if (json == null) {
      result = false;
      return;
    }
    result = json['result'] == true;
    value = json['value'];
  }
}

class FlutterMobileIMSDK {
  static const MethodChannel _channel = const MethodChannel('flutter_MobileIMSDK');

  static setMethodCallHandler({ValueChanged<FlutterMobileIMSDKMethod> handler}) {
    if (handler != null) {
      _channel.setMethodCallHandler((call) async{
        handler.call(FlutterMobileIMSDKMethod.fromMethodCall(call));
      });
    } else {
      _channel.setMethodCallHandler(null);
    }
  }

  static Future<FlutterMobileIMSDKResult> initMobileIMSDK({
    @required String serverIP,
    @required int serverPort,
    String appKey,
    int senseMode,
    bool debug,
  }) {
    Map<String, dynamic> arguments = {};
    arguments['serverIP'] = serverIP;
    arguments['serverPort'] = serverPort;
    if (appKey != null) {
      arguments['appKey'] = appKey;
    }
    if (senseMode != null) {
      arguments['senseMode'] = senseMode;
    }
    if (debug != null) {
      arguments['debug'] = debug;
    }

    return _channel
        .invokeMethod('initMobileIMSDK', arguments)
        .then((value) => FlutterMobileIMSDKResult.fromJson(value));
  }

  static Future<FlutterMobileIMSDKResult> login({
    @required String loginUserIdStr,
    @required int password,
    String extra,
  }) {
    Map<String, dynamic> arguments = {};
    arguments['loginUserIdStr'] = loginUserIdStr;
    arguments['loginTokenStr'] = password;
    if (extra != null) {
      arguments['extra'] = extra;
    }
    return _channel
        .invokeMethod('initMobileIMSDK', arguments)
        .then((value) => FlutterMobileIMSDKResult.fromJson(value));
  }

  static Future<FlutterMobileIMSDKResult> logout() {
    return _channel
        .invokeMethod(
          'initMobileIMSDK',
        )
        .then((value) => FlutterMobileIMSDKResult.fromJson(value));
  }

  static Future<FlutterMobileIMSDKResult> sendMessage({
    @required String dataContent,
    @required String toUserId,
    String fingerPrint,
    bool qos,
    int typeu,
  }) {
    Map<String, dynamic> arguments = {};
    arguments['dataContent'] = dataContent;
    arguments['toUserId'] = toUserId;
    if (fingerPrint != null) {
      arguments['fingerPrint'] = fingerPrint;
    }
    if (qos != null) {
      arguments['qos'] = qos;
    }
    if (typeu != null) {
      arguments['typeu'] = typeu;
    }
    return _channel
        .invokeMethod('initMobileIMSDK', arguments)
        .then((value) => FlutterMobileIMSDKResult.fromJson(value));
  }
}
