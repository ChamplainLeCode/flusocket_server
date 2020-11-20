import 'dart:convert';
import 'dart:io';

import 'package:flusocket_server/core/Logger.dart';
import 'package:flusocket_server/core/SlerverContants.dart';

import 'Server.dart';
import 'SlerverRoute.dart';

class SlerverRouter {
  final Slerver _slerver;
  final SlerverRoute _routes = SlerverRoute();
  final Logger<SlerverRouter> _logger = Logger();

  SlerverRouter(this._slerver) : assert(_slerver != null) {
    _slerver.getServer().listen(newConnection);
  }

  void on(String path, dynamic callback) => _routes.on(path, callback);

  void initMessageReader(Map<Symbol, Object> message) {
    _logger.log('recieve {}', [message]);
  }

  doRouting(Map<Symbol, Object> message) async {
    Map<String, dynamic> meta = Map<String, dynamic>.from(message[#data]);

    final action = this._routes.getAction(meta['path']);

    final params = meta['params'];

    dynamic response;

    if (action != null) {
      response = await action.call(params);
    } else {
      _logger
          .log('Unknown action for {} with params {}', [meta['path'], params]);

      response = null;
    }

    SocketMessage(client: message[#socket], path: meta['path'], data: response)
        .send();
  }

  void newConnection(Socket client) {
    StringBuffer content = StringBuffer();

    _logger.log('New client connected at {}', [client.remoteAddress.host]);

    client.listen((datac) {
      content.write(String.fromCharCodes(datac));

      while (content.length > SlerverConstants.MIN_SIZE) {
        num start = content.toString().indexOf(SlerverConstants.BEGIN),
            end = content.toString().indexOf(SlerverConstants.END);

        String data = content
            .toString()
            .substring(start + SlerverConstants.BEGIN_SIZE, end);

        doRouting({#socket: client, #data: json.decode(data)});

        String rest =
            content.toString().substring(end + SlerverConstants.END_SIZE);

        content.clear();

        content.write(rest);
      }
    });
  }
}

class SocketMessage {
  final Socket client;

  final dynamic data;

  final String path;

  SocketMessage({this.client, this.data, this.path});

  void send() {
    client.write(SlerverConstants.BEGIN +
        json.encode({'path': path, 'params': data}) +
        SlerverConstants.END);
  }
}
