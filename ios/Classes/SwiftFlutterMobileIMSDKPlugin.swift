import Flutter
import UIKit

public class SwiftFlutterMobileIMSDKPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_MobileIMSDK", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterMobileIMSDKPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
