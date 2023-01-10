import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/common/network_info.dart';
import 'package:otlob_gas/common/routes/route_strings.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/authentication/domain/usecases/sign_in_user_use_case.dart';

class SignInProvider {
  final SignInUserUseCase _signInUserUseCase;
  final NetworkInfo _networkInfo;

  SignInProvider(this._signInUserUseCase, this._networkInfo);

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Future<void> signIn({
    required BuildContext context,
  }) async {
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) {
      return;
    }
    Utils.showLoading();

    final result = await _signInUserUseCase(
      mobile: phoneNumberController.text,
      password: passController.text,
    );
    Utils.hideLoading();
    result.fold((failure) {
      Utils.handleFailures(failure);
    }, (_) {
      context.goNamed(RouteStrings.pagesHandler);
    });
  }

  initSignIn() {
    phoneNumberController = TextEditingController();
    passController = TextEditingController();
    listenToNetwork();
  }

  disposePage() async {
    await _networkInfo.listenToNetworkStream.cancel();

    phoneNumberController.dispose();
    passController.dispose();
  }

  listenToNetwork() async {
    _networkInfo.listenToNetworkStream.onData((bool isConnected) {
      if (isConnected) {
        Utils.removeEnhancedDialog(
            dialogName: Utils.localization?.networkFailure ?? '');
      } else {
        Utils.handleFailures(const ConnectionFailure());
      }
    });
  }
}
