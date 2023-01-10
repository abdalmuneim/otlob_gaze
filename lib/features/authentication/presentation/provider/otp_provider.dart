import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:otlob_gas/common/constants/navigator_utils.dart';
import 'package:otlob_gas/common/constants/strings.dart';
import 'package:otlob_gas/common/routes/route_strings.dart';
import 'package:otlob_gas/common/services/navigation_service.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/authentication/domain/usecases/verify_account_use_case.dart';

class OTPProvider extends ChangeNotifier {
  final VerifyAccountUseCase _verifyAccountUseCase;
  OTPProvider(this._verifyAccountUseCase);
  late TextEditingController phoneNumber;
  late TextEditingController code;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// comes from firebase and used for resend code to phone number
  int? _resendToken;

  /// comes from firebase and used for verify phone number
  String? verificationId;

  /// timer in seconds
  late Duration timerDuration = Duration(seconds: _maximumTimerSeconds);

  /// the maximum timer in seconds
  final int _maximumTimerSeconds = 120;

  /// timer instance
  Timer _timer = Timer(Duration.zero, () {});

  // var to identify if we have to go to change password page or to sign in page
  late bool isVerifyAction;

  initPage({required String phoneNumber, required bool isVerifyAction}) {
    this.isVerifyAction = isVerifyAction;
    this.phoneNumber = TextEditingController(text: phoneNumber);
    code = TextEditingController();
    verifyPhoneNumber();
  }

  void disposePage() {
    code.dispose();
    phoneNumber.dispose();
    verificationId = null;
    if (_timer.isActive) {
      _timer.cancel();
    }
  }

  /// send code for phone number
  verifyPhoneNumber() {
    timerDuration = Duration(seconds: _maximumTimerSeconds);

    _auth.verifyPhoneNumber(
        phoneNumber: '${Strings.countryCode}${phoneNumber.text}',
        forceResendingToken: _resendToken,
        verificationCompleted: (_) {},
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            Utils.showErrorToast(Utils.localization?.enter_valid_phone ?? '');
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          _resendToken = resendToken;
          this.verificationId = verificationId;
          notifyListeners();
          _startTimer();
        },
        codeAutoRetrievalTimeout: (_) {},
        timeout: const Duration(minutes: 2));
  }

  /// verify code that has been sent to the phone number
  verifyCode() async {
    FocusScope.of(NavigationService.context).unfocus();
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      final cred = PhoneAuthProvider.credential(
          verificationId: verificationId!, smsCode: code.text);
      await _auth.signInWithCredential(cred);

      if (isVerifyAction) {
        verifyAccountOnBackend();
      } else {
        NavigatorUtils.goToChangePasswordPage(phoneNumber: phoneNumber.text);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        Utils.showErrorToast(
            Utils.localization?.enter_valid_verification_code ?? '');
      }
    }
  }

  /// Verify Account on backend side if phone verification success
  verifyAccountOnBackend() async {
    final result = await _verifyAccountUseCase(mobile: phoneNumber.text);
    result.fold(
        (l) => Utils.handleFailures(l),
        (message) => {
              Utils.showToast(message),
              NavigationService.context.goNamed(RouteStrings.loginPage)
            });
  }

  /// timer start method
  _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timer.tick >= _maximumTimerSeconds) {
        timer.cancel();
        timerDuration = Duration(seconds: _maximumTimerSeconds);
      } else {
        timerDuration = Duration(seconds: _maximumTimerSeconds - timer.tick);
        notifyListeners();
      }
    });
  }
}
