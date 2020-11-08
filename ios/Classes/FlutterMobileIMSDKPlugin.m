#import "FlutterMobileIMSDKPlugin.h"
#if __has_include(<flutter_MobileIMSDK/flutter_MobileIMSDK-Swift.h>)
#import <flutter_MobileIMSDK/flutter_MobileIMSDK-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_MobileIMSDK-Swift.h"
#endif

@implementation FlutterMobileIMSDKPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterMobileIMSDKPlugin registerWithRegistrar:registrar];
}
@end
