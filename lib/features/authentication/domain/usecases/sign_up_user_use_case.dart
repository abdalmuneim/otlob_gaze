import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/authentication/domain/repositories/auth_repository.dart';

class SignUpUserUseCase {
  final AuthRepository repository;

  SignUpUserUseCase(this.repository);

  Future<Either<Failure, String>> call({
    required String name,
    required String email,
    required String mobile,
    required double lat,
    required double long,
    required String image,
    required String address,
    required String password,
    required String confirmPassword,
  }) {
    return repository.signUp(
      name: name,
      email: email,
      image: image,
      mobile: mobile,
      lat: lat,
      long: long,
      address: address,
      confirmPassword: confirmPassword,
      password: password,
    );
  }
}
