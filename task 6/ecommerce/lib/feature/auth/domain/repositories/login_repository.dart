import '../entites/user.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

abstract class LoginRepository {
  Future<Either<Failure,String>> login(User credentials);
}