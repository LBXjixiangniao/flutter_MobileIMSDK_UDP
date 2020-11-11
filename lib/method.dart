import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MobileIMSDKRecieveMessageInfo {
  String fingerPrint;
  String userId;
  String dataContent;
  int typeu;

  MobileIMSDKRecieveMessageInfo({this.fingerPrint, this.userId, this.dataContent, this.typeu});

  MobileIMSDKRecieveMessageInfo.fromJson(Map<dynamic, dynamic> json) {
    fingerPrint = json['fingerPrint'];
    userId = json['userId'];
    dataContent = json['dataContent'];
    typeu = json['typeu'];
  }
}

class MobileIMSDKRecieveProtocal {
  String to;
  String from;
  String fp;
  String dataContent;
  int type;
  int typeu;
  bool bridge;
  bool qoS;

  MobileIMSDKRecieveProtocal({
    this.to,
    this.from,
    this.dataContent,
    this.fp,
    this.type,
    this.typeu,
    this.bridge,
    this.qoS,
  });

  MobileIMSDKRecieveProtocal.fromJson(Map<dynamic, dynamic> json) {
    to = json['to'];
    from = json['from'];
    dataContent = json['dataContent'];
    fp = json['fp'];
    type = json['type'];
    typeu = json['typeu'];
    bridge = json['bridge'];
    qoS = json['qoS'];
  }
}

enum MobileIMSDKMethodType {
  autoReLoginDaemonObserver,
  keepAliveDaemonObserver,
  qoS4SendDaemonObserver,
  qoS4ReciveDaemonObserver,
  loginSuccess,
  loginFail,
  linkClose,
  onRecieveMessage,
  onErrorResponse,
  qosMessagesLost,
  qosMessagesBeReceived,
}

extension MobileIMSDKMethodTypeExtension on MobileIMSDKMethodType {
  static fromMethodCallName(String name) {
    switch (name) {
      case 'AutoReLoginDaemonObserver':
        return MobileIMSDKMethodType.autoReLoginDaemonObserver;
      case 'KeepAliveDaemonObserver':
        return MobileIMSDKMethodType.keepAliveDaemonObserver;
      case 'QoS4SendDaemonObserver':
        return MobileIMSDKMethodType.qoS4SendDaemonObserver;
      case 'QoS4ReciveDaemonObserver':
        return MobileIMSDKMethodType.qoS4ReciveDaemonObserver;
      case 'loginSuccess':
        return MobileIMSDKMethodType.loginSuccess;
      case 'loginFail':
        return MobileIMSDKMethodType.loginFail;
      case 'linkClose':
        return MobileIMSDKMethodType.linkClose;
      case 'onRecieveMessage':
        return MobileIMSDKMethodType.onRecieveMessage;
      case 'onErrorResponse':
        return MobileIMSDKMethodType.onErrorResponse;
      case 'qosMessagesLost':
        return MobileIMSDKMethodType.qosMessagesLost;
      case 'qosMessagesBeReceived':
        return MobileIMSDKMethodType.qosMessagesBeReceived;
    }
    return null;
  }
}

class FlutterMobileIMSDKMethod {
  MobileIMSDKMethodType type;
  dynamic argument;

  FlutterMobileIMSDKMethod(this.type, this.argument);

  factory FlutterMobileIMSDKMethod.fromMethodCall(MethodCall call) {
    MobileIMSDKMethodType type = MobileIMSDKMethodTypeExtension.fromMethodCallName(call.method);
    switch (type) {
      case MobileIMSDKMethodType.autoReLoginDaemonObserver:
      case MobileIMSDKMethodType.keepAliveDaemonObserver:
      case MobileIMSDKMethodType.qoS4SendDaemonObserver:
      case MobileIMSDKMethodType.qoS4ReciveDaemonObserver:
        return MobileIMSDKDaemonOberber(type: type, argument: call.arguments);
      case MobileIMSDKMethodType.loginSuccess:
        return FlutterMobileIMSDKMethod(type, call.arguments);
      case MobileIMSDKMethodType.loginFail:
        return MobileIMSDKLoginFail(type: type, argument: call.arguments);
      case MobileIMSDKMethodType.linkClose:
        return MobileIMSDKLinkClose(type: type, argument: call.arguments);
      case MobileIMSDKMethodType.onRecieveMessage:
        return MobileIMSDKRecieveMessage(type: type, argument: call.arguments);
      case MobileIMSDKMethodType.onErrorResponse:
        return MobileIMSDKErrorResponse(type: type, argument: call.arguments);
      case MobileIMSDKMethodType.qosMessagesLost:
        return MobileIMSDKMessagesLost(type: type, argument: call.arguments);
      case MobileIMSDKMethodType.qosMessagesBeReceived:
        return MobileIMSDKMessagesBeReceived(type: type, argument: call.arguments);
    }
    return null;
  }
}

class MobileIMSDKDaemonOberber extends FlutterMobileIMSDKMethod {
  int status;
  MobileIMSDKDaemonOberber({@required MobileIMSDKMethodType type, dynamic argument}) : super(type, argument) {
    if (argument is int) {
      status = argument;
    }
  }
}

class MobileIMSDKLoginFail extends FlutterMobileIMSDKMethod {
  int errorCode;
  MobileIMSDKLoginFail({@required MobileIMSDKMethodType type, dynamic argument}) : super(type, argument) {
    if (argument is int) {
      errorCode = argument;
    }
  }
}

class MobileIMSDKLinkClose extends FlutterMobileIMSDKMethod {
  int errorCode;
  MobileIMSDKLinkClose({@required MobileIMSDKMethodType type, dynamic argument}) : super(type, argument) {
    if (argument is int) {
      errorCode = argument;
    }
  }
}

class MobileIMSDKRecieveMessage extends FlutterMobileIMSDKMethod {
  MobileIMSDKRecieveMessageInfo info;
  MobileIMSDKRecieveMessage({@required MobileIMSDKMethodType type, dynamic argument})
      : super(type, argument) {
    if (argument is Map) {
      info = MobileIMSDKRecieveMessageInfo.fromJson(argument);
    }
  }
}

class MobileIMSDKErrorResponse extends FlutterMobileIMSDKMethod {
  int errorCode;
  MobileIMSDKErrorResponse({@required MobileIMSDKMethodType type, dynamic argument})
      : super(type, argument) {
    if (argument is int) {
      errorCode = argument;
    }
  }
}

class MobileIMSDKMessagesLost extends FlutterMobileIMSDKMethod {
  List<MobileIMSDKRecieveProtocal> protocalList;
  MobileIMSDKMessagesLost({@required MobileIMSDKMethodType type, dynamic argument})
      : super(type, argument) {
    if (argument is List) {
      protocalList = argument.map((e) => MobileIMSDKRecieveProtocal.fromJson(e)).toList();
    }
  }
}

class MobileIMSDKMessagesBeReceived extends FlutterMobileIMSDKMethod {
  String fingerPrint;
  MobileIMSDKMessagesBeReceived({@required MobileIMSDKMethodType type, dynamic argument}) : super(type, argument) {
    if (argument is String) {
      fingerPrint = argument;
    }
  }
}
