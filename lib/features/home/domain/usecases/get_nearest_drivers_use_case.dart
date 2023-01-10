import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/home/domain/entities/nearest_driver.dart';
import 'package:otlob_gas/features/home/domain/repositories/home_repository.dart';

class GetNearestDriversUseCase {
  final HomeRepository repository;

  GetNearestDriversUseCase(this.repository);

  Future<Either<Failure, List<NearestDriver>>> call(
      {required double lat, required double lng}) async {
    return await repository.getNearestDrivers(lat: lat, lng: lng);
  }
}
