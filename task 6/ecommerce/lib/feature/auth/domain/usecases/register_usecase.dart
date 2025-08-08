import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/register_repository.dart';
import '../entites/user.dart';

class RegisterUsecase {
  final RegisterRepository repository;

  RegisterUsecase({required this.repository});

  Future<Either<Failure, void>> call(User user) {
    return repository.register(user);
  }
}
