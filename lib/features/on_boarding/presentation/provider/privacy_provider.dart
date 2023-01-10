import 'package:flutter/cupertino.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/on_boarding/domain/usecases/get_privacy_use_case.dart';

class PrivacyProvider extends ChangeNotifier {
  final GetPrivacyUseCase _getPrivacyUseCase;
  PrivacyProvider(this._getPrivacyUseCase);

  bool isLoading = true;

  late String privacy;

  getPrivacy() async {
    if (!isLoading) {
      return;
    }
    final result = await _getPrivacyUseCase();
    result.fold((failure) => Utils.handleFailures(failure), (privacy) {
      this.privacy = privacy;
      isLoading = false;
      notifyListeners();
    });
  }
}
