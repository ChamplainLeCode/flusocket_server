import 'dart:async';

import 'package:flutter/services.dart';
export 'package:flusocket_server/core/Server.dart';

class FlusocketServer {
  static const MethodChannel _channel = const MethodChannel('flusocket_server');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
