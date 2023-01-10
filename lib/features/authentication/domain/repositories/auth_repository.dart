import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/authentication/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, String>> signUp({
    required String name,
    required String email,
    required String mobile,
    required double lat,
    required String image,
    required double long,
    required String address,
    required String password,
    required String confirmPassword,
  });
  Future<Either<Failure, String>> editAccount({
    required String name,
    required String mobile,
    required double lat,
    required double long,
    String? image,
    required String address,
    required String password,
    required String confirmPassword,
  });
  Future<Either<Failure, Unit>> signIn({
    required String mobile,
    required String password,
  });
  Future<Either<Failure, String>> recoverAccount({
    required String mobile,
  });
  Future<Either<Failure, Unit>> saveUser({
    required User user,
  });
  Future<Either<Failure, String>> verifyAccount({required String mobile});
  Future<bool> isLoggedIn();
  Future<Either<Failure, Unit>> logOut();
  Future<Either<Failure, String>> changePassword({
    required String mobile,
    required String password,
    required String confirmPassword,
  });
}
