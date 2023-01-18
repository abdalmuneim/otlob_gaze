import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otlob_gas/common/constants/app_colors.dart';
import 'package:otlob_gas/common/constants/assets.dart';
import 'package:otlob_gas/common/constants/validator.dart';
import 'package:otlob_gas/common/extensions.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/authentication/presentation/provider/otp_provider.dart';
import 'package:otlob_gas/widget/custom_button.dart';
import 'package:otlob_gas/widget/custom_text.dart';
import 'package:otlob_gas/widget/custom_text_field.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({
    Key? key,
    required this.phoneNumber,
    required this.isVerifyAction,
  }) : super(key: key);
  final String phoneNumber;
  final bool isVerifyAction;

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  late final OTPProvider otpProvider = context.read<OTPProvider>();
  @override
  void initState() {
    otpProvider.initPage(
        phoneNumber: widget.phoneNumber, isVerifyAction: widget.isVerifyAction);
    super.initState();
  }

  @override
  void dispose() {
    otpProvider.disposePage();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          widget.isVerifyAction
              ? Utils.localization?.verify_your_account
              : Utils.localization?.account_recovery ?? '',
          style: Theme.of(context)
              .textTheme
              .headlineLarge
              ?.copyWith(color: Colors.white, fontSize: 25),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Column(children: [
          const SizedBox(height: 30.0),

          ///   Phone Number Text
          CustomText(
            Utils.localization?.phoneNumber,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 10.0),

          ///   Phone Number TextField
          CustomTextField(
            readOnly: true,
            prefixIcon: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey[300],
                child: SvgPicture.asset(
                  Assets.phoneActive,
                  height: 20,
                )),
            textEditingController: otpProvider.phoneNumber,
          ),
          const SizedBox(height: 30.0),

          ///   Code Text
          CustomText(
            Utils.localization?.verification_code,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 10.0),

          ///   Code Field
          Form(
            key: otpProvider.formKey,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Selector<OTPProvider, String?>(
                  selector: (_, provider) => provider.verificationId,
                  builder: (_, verificationId, __) {
                    return Pinput(
                      enabled: verificationId != null,
                      length: 6,
                      defaultPinTheme: PinTheme(
                        height: 45,
                        width: 45,
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontSize: 26, color: Colors.black),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: AppColors.notActive),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      androidSmsAutofillMethod:
                          AndroidSmsAutofillMethod.smsRetrieverApi,
                      controller: otpProvider.code,
                      onCompleted: (value) {
                        otpProvider.verifyCode();
                      },
                      validator: (value) => AppValidator.validateFields(
                          value, ValidationType.validationCode, context),
                    );
                  }),
            ),
          ),

          const SizedBox(height: 40.0),
          Selector<OTPProvider, Duration>(
              selector: (_, OTPProvider provider) => provider.timerDuration,
              builder: (_, Duration duration, __) {
                final int seconds = duration.inSeconds;
                return TextButton(
                    onPressed:
                        seconds != 0 ? null : otpProvider.verifyPhoneNumber,
                    child: CustomText(Utils.localization!.resend_code +
                        (seconds == 0
                            ? ''
                            : ': ${'${duration.inMinutes.getDurationReminder}:${seconds.remainder(60).getDurationReminder}'}')));
              }),
          const SizedBox(height: 40.0),

          /// sign button
          CustomButton(
            width: double.infinity,
            height: 46,
            onPressed: otpProvider.verifyCode,
            child: CustomText(
              widget.isVerifyAction
                  ? Utils.localization?.verify_your_account
                  : Utils.localization?.account_recovery ?? "",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: Colors.white),
            ),
          ),
        ]),
      ),
    );
  }
}
