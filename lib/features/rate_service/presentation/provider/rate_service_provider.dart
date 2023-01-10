import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:otlob_gas/common/services/navigation_service.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/rate_service/domain/usecases/add_rate_service_use_case.dart';

class RateServiceProvider extends ChangeNotifier {
  final AddRatingUseCase _addRatingUseCase;
  RateServiceProvider(this._addRatingUseCase);
  TextEditingController commentController = TextEditingController();

  double rating = 5.0;
  set setRating(double value) {
    rating = value;
    notifyListeners();
  }

  String? orderId;
  addRating() async {
    Utils.showLoading();
    final result = await _addRatingUseCase(
      orderId: orderId.toString(),
      comment: commentController.text,
      rating: rating.toString(),
    );
    Utils.hideLoading();
    result.fold((failure) {
      Utils.handleFailures(failure);
    }, (message) {
      Utils.showToast(message);
      commentController.clear();
      NavigationService.context.pop();
    });
  }

  initRateServicePage(String orderId) {
    this.orderId = orderId;
    rating = 1.0;
    commentController = TextEditingController();
  }

  disposePage() {
    commentController.dispose();
  }
}
