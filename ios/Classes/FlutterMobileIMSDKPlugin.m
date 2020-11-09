#import "FlutterMobileIMSDKPlugin.h"
#import "ClientCoreSDK.h"
#import "ConfigEntity.h"

@implementation FlutterMobileIMSDKPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_MobileIMSDK"
            binaryMessenger:[registrar messenger]];
  FlutterMobileIMSDKPlugin* instance = [[FlutterMobileIMSDKPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
      [ConfigEntity registerWithAppKey:@""];
  }
}

@end
