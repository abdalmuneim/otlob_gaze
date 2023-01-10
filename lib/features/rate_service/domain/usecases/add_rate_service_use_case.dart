import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/rate_service/domain/repositories/rate_service_repository.dart';

class AddRatingUseCase {
  final RateServiceRepository repository;

  AddRatingUseCase(this.repository);

  Future<Either<Failure, String>> call(
          {required String comment,
          required String rating,
          required String orderId}) async =>
      await repository.addRating(
          comment: comment, orderId: orderId, rating: rating);
}
