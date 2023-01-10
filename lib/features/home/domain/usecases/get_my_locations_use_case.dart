import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/authentication/domain/entities/user_location.dart';
import 'package:otlob_gas/features/home/domain/repositories/home_repository.dart';

class GetMyLocationsUseCase {
  final HomeRepository repository;

  GetMyLocationsUseCase(this.repository);

  Future<Either<Failure, List<UserLocation>>> call() async {
    return await repository.getMyLocations();
  }
}
