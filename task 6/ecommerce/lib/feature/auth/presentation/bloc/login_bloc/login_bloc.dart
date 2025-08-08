import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entites/user.dart';
import '../../../domain/usecases/login_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUsecase loginUsecase;

  LoginBloc({required this.loginUsecase})
    : super(const LoginFormState(isPasswordVisible: false)) {
    on<LoginSubmitted>(_onSigninSubmitted);
    on<TogglePasswordVisibility>(_onTogglePasswordVisibility);
  }

  Future<void> _onSigninSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final credentials = User(
        name: '',
        email: event.email,
        password: event.password,
      );

      final result = await loginUsecase.call(credentials);
      result.fold(
        (failure) {
          emit(LoginError(message: failure.message));
        },
        (token) {
          emit(const LoginSuccess(message: "Welcome! Sign in successful"));
        },
      );
    } catch (error) {
      emit(
        LoginError(
          message: "An unexpected error occurred: ${error.toString()}",
        ),
      );
    }
  }

  void _onTogglePasswordVisibility(
    TogglePasswordVisibility event,
    Emitter<LoginState> emit,
  ) {
    final currentState = state;
    if (currentState is LoginFormState) {
      emit(
        currentState.copyWith(
          isPasswordVisible: !currentState.isPasswordVisible,
        ),
      );
    } else {
      emit(const LoginFormState(isPasswordVisible: true));
    }
  }
}
