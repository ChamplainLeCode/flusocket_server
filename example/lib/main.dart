import 'dart:convert';
import 'dart:io';

import 'package:flusocket_server/flusocket_server.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Slerver server;
  Socket client;
  final String host = '10.42.0.241';
  final int port = 9000;
  @override
  void initState() {
    super.initState();
    startServer();
  }

  startServer() async {
    server = await Slerver.createServer(host, port);
    var router = server.router;
    router.on(
        '/name',
        (Map m) async =>
            {'received': m, 'message': 'Bonjour ${m['name']} ${m['surname']}'});
    router.on('/surname', (List p) async {
      await Future.delayed(Duration(seconds: 5));
      return p?.reversed?.toList();
    });
  }

  startClient() async {
    client = await Socket.connect(host, port);
    client.listen((event) {
      print('[CLIENT] ${String.fromCharCodes(event)}');
    });
  }

  int i = 0;
  clientWrite() {
    client.write(json.encode({
      'path': '/name',
      'params': {'name': 'Bakop', 'surname': 'Champlain'}
    }));
  }

  clientWrite2() {
    client.write(json.encode({
      'path': '/surname',
      'params': ['Champlain', 'Marius', 'Njoba', 'Bakop']
    }));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Row(children: [
          Center(
            child: FloatingActionButton(
              child: Text('Start Server'),
              onPressed: startServer,
            ),
          ),
          SizedBox(width: 100),
          FloatingActionButton(
            child: Text('Send'),
            onPressed: clientWrite,
          ),
          FloatingActionButton(
            child: Text('Send 2'),
            onPressed: clientWrite2,
          )
        ]),
        floatingActionButton: FloatingActionButton(
          child: Text('Start client'),
          onPressed: startClient,
        ),
      ),
    );
  }
}
