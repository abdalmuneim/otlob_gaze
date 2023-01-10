import 'package:flutter/cupertino.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/on_boarding/domain/usecases/get_about_app_use_case.dart';

class AboutAppProvider extends ChangeNotifier {
  final GetAboutAppUseCase _getAboutAppUseCase;
  AboutAppProvider(this._getAboutAppUseCase);

  bool isLoading = true;

  late String aboutApp;

  geAboutApp() async {
    if (!isLoading) {
      return;
    }
    final result = await _getAboutAppUseCase();
    result.fold((failure) => Utils.handleFailures(failure), (aboutApp) {
      this.aboutApp = aboutApp;
      isLoading = false;
      notifyListeners();
    });
  }
}
