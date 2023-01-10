import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:otlob_gas/common/routes/route_strings.dart';
import 'package:otlob_gas/common/services/navigation_service.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/authentication/domain/usecases/change_password_use_case.dart';

class ChangePasswordProvider {
  late String mobile;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  BuildContext get context => NavigationService.context;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final ChangePasswordUseCase _changePasswordUseCase;
  ChangePasswordProvider(
    this._changePasswordUseCase,
  );

  Future<void> changePassword() async {
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) {
      return;
    }
    Utils.showLoading();
    final result = await _changePasswordUseCase(
      mobile: mobile,
      confirmPassword: confirmPasswordController.text,
      password: passwordController.text,
    );
    Utils.hideLoading();

    result.fold((l) => Utils.handleFailures(l), (message) {
      context.goNamed(RouteStrings.loginPage);
      Utils.showToast(message);
    });
  }

  initPage(String mobile) {
    this.mobile = mobile;
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  disposePage() {
    mobile = '';
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
