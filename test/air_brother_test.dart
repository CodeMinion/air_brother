import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:air_brother/air_brother.dart';

void main() {
  const MethodChannel channel = MethodChannel('air_brother');

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
    expect(await AirBrother.platformVersion, '42');
  });
}
