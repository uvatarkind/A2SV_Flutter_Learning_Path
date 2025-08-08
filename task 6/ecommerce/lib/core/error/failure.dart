
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final List properties;

  const Failure(this.message, [this.properties = const <dynamic>[]]);

  @override
  List<Object?> get props => [message, ...properties];
}

class ServerFailure extends Failure {
  const ServerFailure({required String message}) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure({required String message}) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure({required String message}) : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure({required String message}) : super(message);
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure({required String message}) : super(message);
}


