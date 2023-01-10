import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/authentication/domain/entities/user_location.dart';
import 'package:otlob_gas/features/home/domain/repositories/home_repository.dart';

class AddMyLocationUseCase {
  final HomeRepository repository;

  AddMyLocationUseCase(this.repository);

  Future<Either<Failure, UserLocation>> call(
      {required double lat,
      required double long,
      required String title,
      required String floorNumber,
      required String buildingNumber,
      required bool isDefault}) async {
    return await repository.addLocation(
        lat: lat,
        long: long,
        title: title,
        floorNumber: floorNumber,
        buildingNumber: buildingNumber,
        isDefault: isDefault);
  }
}
