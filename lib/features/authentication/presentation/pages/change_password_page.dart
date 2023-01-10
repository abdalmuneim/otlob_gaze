import 'package:flutter/material.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/authentication/presentation/provider/change_password_provider.dart';
import 'package:otlob_gas/features/authentication/presentation/widgets/password_text_field.dart';
import 'package:otlob_gas/widget/custom_button.dart';
import 'package:otlob_gas/widget/custom_text.dart';
import 'package:provider/provider.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key, required this.mobile});
  final String mobile;
  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late final ChangePasswordProvider changePasswordProvider =
      context.read<ChangePasswordProvider>();
  @override
  void initState() {
    changePasswordProvider.initPage(widget.mobile);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    changePasswordProvider.disposePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          Utils.localization?.reset_the_password ?? '',
          style: Theme.of(context)
              .textTheme
              .headlineLarge
              ?.copyWith(color: Colors.white, fontSize: 25),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Form(
          key: changePasswordProvider.formKey,
          child: Column(children: [
            const SizedBox(height: 50.0),

            /// text password
            CustomText(Utils.localization?.pass),
            const SizedBox(height: 10),

            /// form password
            PasswordTextField(
              controller: changePasswordProvider.passwordController,
            ),

            const SizedBox(height: 20),

            /// text confirm password
            CustomText(Utils.localization?.confirmPass),
            const SizedBox(height: 10),

            /// form confirm password
            PasswordTextField(
              controller: changePasswordProvider.confirmPasswordController,
            ),

            const SizedBox(height: 20),
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
              onPressed: changePasswordProvider.changePassword,
              child: CustomText(
                Utils.localization?.reset_the_password ?? "",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: Colors.white),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
