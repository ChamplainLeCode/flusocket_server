import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flusocket_server/flusocket_server.dart';

void main() {
  const MethodChannel channel = MethodChannel('flusocket_server');

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
    expect(await FlusocketServer.platformVersion, '42');
  });
}
