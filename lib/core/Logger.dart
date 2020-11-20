class Logger<T> {
  void log(String message, List<Object> params) {
    params.forEach((param) => message = message.replaceFirst('{}', '$param'));
    print('-- ${DateTime.now()} ${this.runtimeType}.${T.runtimeType} $message');
  }
}
