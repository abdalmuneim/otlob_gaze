import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/common/hold_message_with.dart';
import 'package:otlob_gas/features/authentication/domain/entities/user_location.dart';
import 'package:otlob_gas/features/home/domain/entities/ads.dart';
import 'package:otlob_gas/features/home/domain/entities/nearest_driver.dart';
import 'package:otlob_gas/features/home/domain/entities/order_status.dart';

abstract class HomeRepository {
  Future<Either<Failure, Unit>> changeUserActivity({required bool isActive});
  Future<Either<Failure, List<NearestDriver>>> getNearestDrivers(
      {required double lat, required double lng});
  Future<Either<Failure, List<UserLocation>>> getMyLocations();
  Future<Either<Failure, List<Ads>>> getAds();
  Future<Either<Failure, OrderStatus>> getOrderStatus();
  Future<Either<Failure, UserLocation>> addLocation(
      {required double lat,
      required double long,
      required String title,
      required String floorNumber,
      required String buildingNumber,
      required bool isDefault});

  Future<Either<Failure, UserLocation>> editLocation(
      {double? lat,
      double? long,
      String? title,
      String? floorNumber,
      String? buildingNumber,
      bool? isDefault,
      required int locationId});
  Future<Either<Failure, HoldMessageWith<double>>> chargeBalance(
      {required String cardNumber});
}
