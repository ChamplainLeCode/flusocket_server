//typedef ArgumentCallback = void Function<String>(String params);

typedef ArgumentCallback<T, M> = Future<T> Function(M);

class SlerverRoute {
  static Map<String, dynamic> routes = {};

  void on(String path, dynamic callback) => routes[path] = callback;

  getAction(String path) => routes[path];
}
