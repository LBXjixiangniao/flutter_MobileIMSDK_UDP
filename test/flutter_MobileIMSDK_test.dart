import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_MobileIMSDK/flutter_MobileIMSDK.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_MobileIMSDK');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterMobileIMSDK.platformVersion, '42');
  });
}
