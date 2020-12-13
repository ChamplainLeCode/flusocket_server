import 'dart:async';
import 'dart:io';
import 'package:flusocket_server/core/Logger.dart';
import 'package:flusocket_server/core/SlerverRouter.dart';
import 'package:get_ip/get_ip.dart';

class Slerver {
  final Map<String, ServerSocket> serverSockets = {};
  final Logger<Slerver> l = Logger();
  final StreamController<Map<Symbol, Object>> _dataStream = StreamController();

  factory Slerver(String address, int port) => Slerver._internal(address, port);

  Slerver._internal(String address, int port)
      : assert(address != null && port != null) {
    _initServer(address, port);
  }

  Slerver._empty();

  SlerverRouter get router => SlerverRouter(this);

  static Future<Slerver> createServer(String address, int port) async {
    assert(address != null && port != null);
    return await Slerver._empty()._initServer(address, port);
  }

  Future<Slerver> _initServer(String address, int port) async {
    String serverCode = Slerver.hashAddress(address, port);
    ServerSocket serv;
    if (!serverSockets.containsKey(serverCode))
      serverSockets[serverCode] = serv = await ServerSocket.bind(address, port);
    else
      serv = serverSockets[serverCode];
    l.log('Server start at {} port {} ', [serv.address.host, serv.port]);
    return this;
  }

  Future<String> getIP() => GetIp.ipAddress;

  StreamController<Map<Symbol, Object>> get controller => _dataStream;

  ServerSocket getServer([String address, int port]) {
    if (address == null || port == null) {
      if (serverSockets.length > 0) {
        return serverSockets.entries.map((entry) => entry.value).first;
      }
      return null;
    }
    return serverSockets[Slerver.hashAddress(address, port)];
  }

  void close([String address, int port]) {
    ServerSocket server = getServer(address, port);
    // server?.forEach((cli) {
    //   cli.close();
    //   cli.destroy();
    // });
    server?.close();
    _dataStream?.close();
  }

  static String hashAddress(String address, int port) {
    assert(address != null && port != null, 'Address or port cannot be null');
    return '$address:$port';
  }
}
