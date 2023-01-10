import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/authentication/domain/repositories/auth_repository.dart';

class EditAccountUseCase {
  final AuthRepository repository;

  EditAccountUseCase(this.repository);

  Future<Either<Failure, String>> call({
    required String name,
    required String mobile,
    required double lat,
    required double long,
    String? image,
    required String address,
    required String password,
    required String confirmPassword,
  }) async {
    return await repository.editAccount(
      name: name,
      mobile: mobile,
      lat: lat,
      long: long,
      image: image,
      address: address,
      confirmPassword: confirmPassword,
      password: password,
    );
  }
}
