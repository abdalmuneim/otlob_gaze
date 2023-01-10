import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/authentication/domain/entities/user_location.dart';
import 'package:otlob_gas/features/home/domain/repositories/home_repository.dart';

class EditMyLocationUseCase {
  final HomeRepository repository;

  EditMyLocationUseCase(this.repository);

  Future<Either<Failure, UserLocation>> call(
      {double? lat,
      double? long,
      String? title,
      String? floorNumber,
      String? buildingNumber,
      required int locationId,
      bool? isDefault}) async {
    return await repository.editLocation(
        locationId: locationId,
        lat: lat,
        long: long,
        title: title,
        floorNumber: floorNumber,
        buildingNumber: buildingNumber,
        isDefault: isDefault);
  }
}
