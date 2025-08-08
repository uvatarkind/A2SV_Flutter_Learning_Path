import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entites/user.dart';

abstract class RegisterRepository {
  Future<Either<Failure,void>> register(User user);
}