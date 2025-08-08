import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/network/network_info.dart';
import '../../domain/entites/user.dart';
import '../../domain/repositories/register_repository.dart';
import '../datasource/local_data_source.dart';
import '../datasource/remote_data_source.dart';
import '../model/user_model.dart';

class RegisterRepo implements RegisterRepository {
  final LocalDataSource localDataSource;
  final RemoteDataSource remoteDatasource;
  final NetworkInfo networkInfo;

  RegisterRepo({
    required this.localDataSource,
    required this.remoteDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> register(User user) async {
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      print('❌ Repository: No network connection detected');
      return const Left(
        NetworkFailure(
          message:
              'No internet connection. Please check your network and try again.',
        ),
      );
    }

    try {
      print('✅ Repository: Network connection confirmed');

      final userModel = UserModel(
        name: user.name,
        email: user.email,
        password: user.password,
      );
      final result = await remoteDatasource.register(userModel);
      try {
        await localDataSource.cacheUser(result);
      } catch (cacheError) {
        print('⚠️ Repository: Cache warning (non-critical): $cacheError');
      }
      
      return const Right(null);
    } on SocketException catch (e) {
      return const Left(
        NetworkFailure(
          message: 'Connection failed. Please check your internet connection.',
        ),
      );
    } on HttpException catch (e) {
      return const Left(
        NetworkFailure(message: 'Network request failed. Please try again.'),
      );
    } on FormatException catch (e) {
      return const Left(
        ServerFailure(
          message: 'Invalid response from server. Please try again.',
        ),
      );
    } catch (e) {
      final errorMessage = e.toString().toLowerCase();
      print('💥 Repository: Lowercase error message: $errorMessage');

      if (errorMessage.contains('network error') ||
          errorMessage.contains('connection') ||
          errorMessage.contains('timeout') ||
          errorMessage.contains('socket')) {
        print('❌ Repository: Classified as network error');
        return const Left(
          NetworkFailure(
            message: 'Connection problem. Please check your internet.',
          ),
        );
      } else if (errorMessage.contains('email already exists') ||
          errorMessage.contains('already registered')) {
        return const Left(
          ServerFailure(
            message:
                'Email address is already registered. Please use a different email.',
          ),
        );
      } else if (errorMessage.contains('invalid email')) {
        print('❌ Repository: Classified as invalid email error');
        return const Left(
          ServerFailure(message: 'Please provide a valid email address.'),
        );
      } else if (errorMessage.contains('password')) {
        print('❌ Repository: Classified as password error');
        return const Left(
          ServerFailure(
            message: 'Password does not meet security requirements.',
          ),
        );
      } else {
        return const Left(
          ServerFailure(message: 'Account creation failed. Please try again.'),
        );
      }
    }
  }
}
