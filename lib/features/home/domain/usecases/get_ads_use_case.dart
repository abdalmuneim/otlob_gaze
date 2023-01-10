import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/home/domain/entities/ads.dart';
import 'package:otlob_gas/features/home/domain/repositories/home_repository.dart';

class GetAdsUseCase {
  final HomeRepository repository;

  GetAdsUseCase(this.repository);

  Future<Either<Failure, List<Ads>>> call() async {
    return await repository.getAds();
  }
}
