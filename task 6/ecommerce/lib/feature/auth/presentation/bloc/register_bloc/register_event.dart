import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
  @override
  List<Object> get props => [];
}

class RegisterSubmitted extends RegisterEvent {
  final String name;
  final String password;
  final String email;
  final String confirmPassword;

  const RegisterSubmitted({
    required this.name,
    required this.confirmPassword,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [name, password, confirmPassword, email];
}

class TogglePasswordVisibility extends RegisterEvent{

}

class ToggleConfirmPasswordVisibility extends RegisterEvent{}

class ToggleTermsAcceptance extends RegisterEvent{}