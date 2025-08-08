
import 'package:equatable/equatable.dart';

abstract class LoginState  extends Equatable{
  const LoginState ();
  @override
  List<Object>get props => [];

}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String message;
  const LoginSuccess({
    required this.message
  });
}

class LoginError extends LoginState {
  final String message;
  const LoginError({
    required this.message
  });
}

class LoginFormState extends LoginState {
  final bool isPasswordVisible;
  const LoginFormState({
    required this.isPasswordVisible
  });

  LoginFormState copyWith({
    bool? isPasswordVisible
  }){
    return LoginFormState(isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible);
  }
  @override
  List<Object> get props => [isPasswordVisible,];
}