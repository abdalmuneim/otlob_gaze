import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/exception.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/authentication/data/datasources/auth_local_data_source.dart';
import 'package:otlob_gas/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:otlob_gas/features/authentication/data/models/user_model.dart';
import 'package:otlob_gas/features/authentication/domain/entities/user.dart';
import 'package:otlob_gas/features/authentication/domain/repositories/auth_repository.dart';
import 'package:otlob_gas/features/on_boarding/domain/usecases/get_language_use_case.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final GetLanguageUseCase getLanguageUseCase;

  AuthRepositoryImpl(
      {required this.getLanguageUseCase,
      required this.remoteDataSource,
      required this.localDataSource});

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      late UserModel user;
      if (await localDataSource.isLoggedIn()) {
        user = await localDataSource.getCurrentUser();
      } else {
        throw UnAuthorizedException();
      }
      return Right(user);
    } on UnAuthorizedException {
      return const Left(UnAuthorizedFailure());
    } on DataBaseException {
      return const Left(DatabaseFailure());
    } catch (error) {
      return Left(ExceptionFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signIn(
      {required String mobile, required String password}) async {
    try {
      final result = await remoteDataSource.signIn(
        mobile: mobile,
        password: password,
        currentLanguage: getLanguageUseCase(),
      );

      await localDataSource.saveCurrentUser(userModel: result);

      return const Right(unit);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } on UnAuthorizedException {
      return const Left(UnAuthorizedFailure());
    } on UnVerifiedException catch (e) {
      return Left(UnVerifiedFailure(phoneNumber: e.phoneNumber));
    } on DataBaseException {
      return const Left(DatabaseFailure());
    } catch (error) {
      return Left(ExceptionFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> signUp({
    required String name,
    required String email,
    required String mobile,
    required double lat,
    required double long,
    required String image,
    required String address,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final result = await remoteDataSource.signUp(
        name: name,
        email: email,
        mobile: mobile,
        lat: lat,
        image: image,
        long: long,
        currentLanguage: getLanguageUseCase(),
        address: address,
        confirmPassword: confirmPassword,
        password: password,
      );

      return Right(result);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } on UnAuthorizedException {
      return const Left(UnAuthorizedFailure());
    } on UnVerifiedException catch (e) {
      return Left(UnVerifiedFailure(phoneNumber: e.phoneNumber));
    } on DataBaseException {
      return const Left(DatabaseFailure());
    } catch (error) {
      return Left(ExceptionFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> editAccount({
    required String name,
    required String mobile,
    required double lat,
    required double long,
    String? image,
    required String address,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final String? token = await localDataSource.getUserToken;
      if (token == null) {
        throw UnAuthorizedException;
      }
      final result = await remoteDataSource.editAccount(
        name: name,
        mobile: mobile,
        lat: lat,
        long: long,
        image: image,
        address: address,
        confirmPassword: confirmPassword,
        password: password,
        token: token,
      );

      await localDataSource.saveCurrentUser(userModel: result.data);
      return Right(result.message);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } on UnAuthorizedException {
      return const Left(UnAuthorizedFailure());
    } on DataBaseException {
      return const Left(DatabaseFailure());
    } catch (error) {
      return Left(ExceptionFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> recoverAccount(
      {required String mobile}) async {
    try {
      final result = await remoteDataSource.recoverAccount(mobile: mobile);

      return Right(result);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } on UnAuthorizedException {
      return const Left(UnAuthorizedFailure());
    } on UnVerifiedException catch (e) {
      return Left(UnVerifiedFailure(phoneNumber: e.phoneNumber));
    } on DataBaseException {
      return const Left(DatabaseFailure());
    } catch (error) {
      return Left(ExceptionFailure(message: error.toString()));
    }
  }

  @override
  Future<bool> isLoggedIn() => localDataSource.isLoggedIn();

  @override
  Future<Either<Failure, Unit>> logOut() async {
    try {
      final String? token = await localDataSource.getUserToken;
      if (token == null) {
        throw UnAuthorizedException;
      }

      await localDataSource.logOut();
      await remoteDataSource.logOut(token: token);

      return const Right(unit);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } on UnAuthorizedException {
      return const Left(UnAuthorizedFailure());
    } catch (error) {
      return Left(ExceptionFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveUser({required User user}) async {
    try {
      await localDataSource.saveCurrentUser(
          userModel: UserModel(
        id: user.id,
        name: user.name,
        email: user.email,
        mobile: user.mobile,
        image: user.image,
        isActive: user.isActive,
        imageForWeb: user.imageForWeb,
        status: user.status,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt,
        address: user.address,
        location: user.location,
      ));

      return const Right(unit);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } on UnAuthorizedException {
      return const Left(UnAuthorizedFailure());
    } catch (error) {
      return Left(ExceptionFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> changePassword(
      {required String mobile,
      required String password,
      required String confirmPassword}) async {
    try {
      final result = await remoteDataSource.changePassword(
          mobile: mobile, password: password, confirmPassword: confirmPassword);

      return Right(result);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } on UnAuthorizedException {
      return const Left(UnAuthorizedFailure());
    } catch (error) {
      return Left(ExceptionFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> verifyAccount(
      {required String mobile}) async {
    try {
      final result = await remoteDataSource.verifyAccount(
        mobile: mobile,
      );
      return Right(result);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } on UnAuthorizedException {
      return const Left(UnAuthorizedFailure());
    } catch (error) {
      return Left(ExceptionFailure(message: error.toString()));
    }
  }
}
