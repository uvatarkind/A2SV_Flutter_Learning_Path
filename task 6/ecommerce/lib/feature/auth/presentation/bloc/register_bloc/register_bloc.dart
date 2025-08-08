import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/register_usecase.dart';
import '../../../domain/entites/user.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUsecase registerUsecase;

  RegisterBloc({required this.registerUsecase})
      : super(const RegisterFormState(
          isPasswordVisible: false,
          isConfirmPasswordVisible: false,
          isTermsAccepted: false,
        )) {

    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<TogglePasswordVisibility>(_onTogglePasswordVisibility);
    on<ToggleConfirmPasswordVisibility>(_onToggleConfirmPasswordVisibility);
    on<ToggleTermsAcceptance>(_onToggleTermsAcceptance);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(const RegisterLoading());

    try {
    
      if (event.password != event.confirmPassword) {
        emit(const RegisterError(message: "Passwords don't match"));
        return;
      }

      final user = User(
        name: event.name,
        email: event.email,
        password: event.password,
      );

      final result = await registerUsecase.call(user);
      result.fold(
        (failure) {
          emit(RegisterError(message: failure.message));
        },
        (_) {
          emit(const RegisterSuccess(message: "Account created successfully!"));
        },
      );

    } catch (error) {
      emit(RegisterError(message: "An unexpected error occurred: ${error.toString()}"));
    }
  }

  void _onTogglePasswordVisibility(
    TogglePasswordVisibility event,
    Emitter<RegisterState> emit,
  ) {
    final currentState = state;
    if (currentState is RegisterFormState) {
      emit(currentState.copyWith(
        isPasswordVisible: !currentState.isPasswordVisible,
      ));
    } else {
      emit(const RegisterFormState(isPasswordVisible: true));
    }
  }

  void _onToggleConfirmPasswordVisibility(
    ToggleConfirmPasswordVisibility event,
    Emitter<RegisterState> emit,
  ) {
    final currentState = state;
    if (currentState is RegisterFormState) {
      emit(currentState.copyWith(
        isConfirmPasswordVisible: !currentState.isConfirmPasswordVisible,
      ));
    } else {
      emit(const RegisterFormState(isConfirmPasswordVisible: true));
    }
  }

  void _onToggleTermsAcceptance(
    ToggleTermsAcceptance event,
    Emitter<RegisterState> emit,
  ) {
    final currentState = state;
    if (currentState is RegisterFormState) {
      emit(currentState.copyWith(
        isTermsAccepted: !currentState.isTermsAccepted,
      ));
    } else {
      emit(const RegisterFormState(isTermsAccepted: true));
    }
  }
}