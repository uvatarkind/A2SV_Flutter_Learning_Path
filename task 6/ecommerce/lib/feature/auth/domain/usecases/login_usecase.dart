import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/login_repository.dart';
import '../entites/user.dart';

class LoginUsecase {
  final LoginRepository repository;

  LoginUsecase({required this.repository});

  Future<Either<Failure, String>> call(User credentials)async {
    return repository.login(credentials);
  }
}
