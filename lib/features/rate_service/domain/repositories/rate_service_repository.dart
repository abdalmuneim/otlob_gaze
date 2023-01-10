import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';

abstract class RateServiceRepository {
  Future<Either<Failure, String>> addRating({
    required String comment,
    required String orderId,
    required String rating,
  });
}
