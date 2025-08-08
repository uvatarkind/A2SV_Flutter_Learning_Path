import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/network/network_info.dart';
import '../../domain/entites/user.dart';
import '../../domain/repositories/login_repository.dart';
import '../datasource/local_data_source.dart';
import '../datasource/remote_data_source.dart';
import '../model/user_model.dart';

class LoginRepo implements LoginRepository {
  final LocalDataSource localDatasource;
  final RemoteDataSource remoteDatasource;
  final NetworkInfo networkInfo;

  LoginRepo({
    required this.localDatasource,
    required this.remoteDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, String>> login(User credentials) async {
    print('🏪 SigninRepository: signin method called');
    print('🏪 SigninRepository: Email: ${credentials.email}');

    // ✅ Debug network connectivity
    print('📡 SigninRepository: Checking network connectivity...');
    try {
      final isConnected = await networkInfo.isConnected;
      print('📡 SigninRepository: Network connected: $isConnected');

      if (!isConnected) {
        print('❌ SigninRepository: No network connection detected');
        return const Left(
          NetworkFailure(
            message:
                'No internet connection. Please check your network and try again.',
          ),
        );
      }
    } catch (networkError) {
      print('SigninRepository: Network check failed: $networkError');
      // Continue anyway - maybe network check is broken but internet works
    }

    try {
      print("attempt");
      final userModel = UserModel(
        name: '', // Empty for signin
        email: credentials.email,
        password: credentials.password,
      );
      final accessToken = await remoteDatasource.login(userModel);
      try {
        await localDatasource.saveToken(accessToken);
      } catch (cacheError) {
        print(
          'SigninRepository: Token storage warning (non-critical): $cacheError',
        );
      }

      print('🎉 SigninRepository: Signin process completed successfully!');
      return Right(accessToken);
    } on SocketException catch (e) {
      print('SigninRepository: SocketException details: $e');
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

      if (errorMessage.contains('network error') ||
          errorMessage.contains('connection') ||
          errorMessage.contains('timeout') ||
          errorMessage.contains('socket')) {
        return const Left(
          NetworkFailure(
            message: 'Connection problem. Please check your internet.',
          ),
        );
      } else if (errorMessage.contains('invalid credentials') ||
          errorMessage.contains('unauthorized') ||
          errorMessage.contains('sign in failed') ||
          errorMessage.contains('login failed') ||
          errorMessage.contains('authentication failed')) {
        return const Left(
          ServerFailure(
            message:
                'Invalid email or password. Please check your credentials.',
          ),
        );
      } else if (errorMessage.contains('user not found') ||
          errorMessage.contains('account not found')) {
        return const Left(
          ServerFailure(
            message: 'Account not found. Please check your email or sign up.',
          ),
        );
      } else {
        return const Left(
          ServerFailure(message: 'Login failed. Please try again.'),
        );
      }
    }
  }
}
