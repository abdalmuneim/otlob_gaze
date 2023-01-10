import 'package:flutter/cupertino.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/on_boarding/domain/usecases/get_terms_use_case.dart';

class TermsProvider extends ChangeNotifier {
  final GetTermsUseCase _getTermsUseCase;
  TermsProvider(this._getTermsUseCase);

  bool isLoading = true;

  late String terms;

  getTerms() async {
    if (!isLoading) {
      return;
    }
    final result = await _getTermsUseCase();
    result.fold((failure) => Utils.handleFailures(failure), (terms) {
      this.terms = terms;
      isLoading = false;
      notifyListeners();
    });
  }
}
