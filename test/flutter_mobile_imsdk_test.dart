import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mobile_imsdk/flutter_mobile_imsdk.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_mobile_imsdk');

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
    expect(await FlutterMobileImsdk.platformVersion, '42');
  });
}
