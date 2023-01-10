import 'package:flutter/cupertino.dart';
import 'package:otlob_gas/common/constants/navigator_utils.dart';
import 'package:otlob_gas/common/services/navigation_service.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/authentication/domain/usecases/recover_account_user_use_case.dart';

class RecoverAccountProvider {
  late TextEditingController mobileController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RecoverAccountUserUseCase _recoverAccountUserUseCase;

  RecoverAccountProvider(
    this._recoverAccountUserUseCase,
  );

  Future<void> recoverAccount() async {
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) {
      return;
    }
    Utils.showLoading();
    final result =
        await _recoverAccountUserUseCase(mobile: mobileController.text);
    Utils.hideLoading();

    result.fold((failure) => Utils.handleFailures(failure), (message) {
      Utils.showToast(message);
      NavigatorUtils.goToOTPPage(
          isVerifyAction: false, phoneNumber: mobileController.text);
    });
  }

  BuildContext get context => NavigationService.context;
  initPage() {
    mobileController = TextEditingController();
  }

  disposePage() {
    mobileController.dispose();
  }
}
