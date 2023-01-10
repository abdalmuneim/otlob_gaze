import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otlob_gas/common/constants/assets.dart';
import 'package:otlob_gas/common/constants/validator.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/authentication/presentation/provider/recover_account_provider.dart';
import 'package:otlob_gas/widget/custom_button.dart';
import 'package:otlob_gas/widget/custom_text.dart';
import 'package:otlob_gas/widget/custom_text_field.dart';
import 'package:provider/provider.dart';

class RecoverAccountPage extends StatefulWidget {
  const RecoverAccountPage({super.key});

  @override
  State<RecoverAccountPage> createState() => _RecoverAccountPageState();
}

class _RecoverAccountPageState extends State<RecoverAccountPage> {
  late final RecoverAccountProvider recoverAccountProvider =
      context.read<RecoverAccountProvider>();
  @override
  void initState() {
    recoverAccountProvider.initPage();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    recoverAccountProvider.disposePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          Utils.localization?.account_recovery ?? '',
          style: Theme.of(context)
              .textTheme
              .headlineLarge
              ?.copyWith(color: Colors.white, fontSize: 25),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Column(children: [
          const SizedBox(height: 20.0),
          CustomText(
            Utils.localization?.account_recovery_note,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30.0),

          ///   phone number
          CustomText(
            Utils.localization?.phoneNumber,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 10.0),

          ///   phone number
          Form(
            key: recoverAccountProvider.formKey,
            child: CustomTextField(
              prefixText: '     ',
              prefixIcon: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey[300],
                  child: SvgPicture.asset(Assets.phoneActive)),
              hintText: Utils.localization?.hint_phone ?? "",
              textEditingController: recoverAccountProvider.mobileController,
              validator: (value) => AppValidator.validateFields(
                  value, ValidationType.phone, context),
            ),
          ),
          /* 
          const SizedBox(height: 30.0),
          ///   Or
          CustomText(
            Utils.localization?.or,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeightManger.bold),
          ),
          const SizedBox(height: 30.0),

           ///   Email address
          CustomText(
            Utils.localization?.mail,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 10.0),

          ///   Email address
          Form(
            key: recoverAccountProvider.formKey,
            child: CustomTextField(
              prefixText: '     ',
              prefixIcon: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey[300],
                  child: SvgPicture.asset(
                    Assets.messagesIC,
                    height: 20,
                  )),
              hintText: Utils.localization?.hint_email ?? "",
              textEditingController:
                  recoverAccountProvider.emailAddressController,
              validator: (value) => AppValidator.validateFields(
                  value, ValidationType.email, context),
            ),
          ), */

          const SizedBox(height: 40.0),

          /// sign button
          CustomButton(
            width: double.infinity,
            height: 46,
            onPressed: recoverAccountProvider.recoverAccount,
            child: CustomText(
              Utils.localization?.account_recovery ?? "",
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
