import 'dart:async';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

/// This mixin is used to get the current status of authentication
/// Added to the [AuthenticationRepository]
mixin AuthenticationStatusService {

  final StreamController<AuthenticationStatus> _controller = StreamController<AuthenticationStatus>();
  StreamController<AuthenticationStatus> get controller => _controller;

  Stream<AuthenticationStatus> get status async* {
    await Future.delayed(Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }
  void dispose() => _controller.close();

}