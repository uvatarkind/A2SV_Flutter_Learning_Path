import 'package:equatable/equatable.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();
  
  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

class RegisterSuccess extends RegisterState {
  final String message;
  
  const RegisterSuccess({required this.message});
  
  @override
  List<Object> get props => [message];
}

class RegisterError extends RegisterState {
  final String message;
  
  const RegisterError({required this.message});
  
  @override
  List<Object> get props => [message];
}

class RegisterFormState extends RegisterState {
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool isTermsAccepted;
  
  const RegisterFormState({
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.isTermsAccepted = false,
  });
  
  RegisterFormState copyWith({
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    bool? isTermsAccepted,
  }) {
    return RegisterFormState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible: isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      isTermsAccepted: isTermsAccepted ?? this.isTermsAccepted,
    );
  }
  
  @override
  List<Object> get props => [
    isPasswordVisible,
    isConfirmPasswordVisible,
    isTermsAccepted,
  ];
}