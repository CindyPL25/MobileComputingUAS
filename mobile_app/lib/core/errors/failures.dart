class AppFailure implements Exception {
  AppFailure(this.message);

  final String message;

  @override
  String toString() => 'AppFailure: $message';
}

class UnimplementedRemoteFailure extends AppFailure {
  UnimplementedRemoteFailure()
      : super('Remote data source is not implemented yet.');
}
