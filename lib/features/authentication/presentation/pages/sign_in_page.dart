import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:otlob_gas/common/constants/app_colors.dart';
import 'package:otlob_gas/common/constants/assets.dart';
import 'package:otlob_gas/common/constants/validator.dart';
import 'package:otlob_gas/common/routes/route_strings.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/authentication/presentation/provider/sign_in_provider.dart';
import 'package:otlob_gas/features/authentication/presentation/widgets/password_text_field.dart';
import 'package:otlob_gas/features/on_boarding/presentation/provider/splash_provider.dart';
import 'package:otlob_gas/widget/custom_button.dart';
import 'package:otlob_gas/widget/custom_text.dart';
import 'package:otlob_gas/widget/custom_text_field.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late final signInProvider = context.read<SignInProvider>();
  @override
  void initState() {
    signInProvider.initSignIn();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    signInProvider.disposePage();
  }

  @override
  Widget build(BuildContext context) {
    final SignInProvider signInProvider = context.read<SignInProvider>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// top image
            SizedBox(
              height: 240,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: AppColors.splash,
                ),
                child: Padding(
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(),
                          Image.asset(Assets.otlobGas, height: 120, width: 120),
                          const Spacer(flex: 4),
                          Column(
                            children: [
                              const SizedBox(height: 5.0),
                              Image.asset(Assets.splashTop,
                                  height: 60, width: 60),
                              Image.asset(Assets.splashCenter,
                                  height: 120, width: 150),
                            ],
                          ),
                          const SizedBox(width: 10.0),
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        child: Transform.translate(
                          offset: const Offset(0, 0.5),
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(Utils.isRTL ? 0 : pi),
                            child: CustomPaint(
                              size: Size(MediaQuery.of(context).size.width,
                                  (60).toDouble()),
                              //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                              painter: RPSCustomPainter(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: signInProvider.formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),

                        /// login text
                        CustomText(
                          Utils.localization?.login ?? "",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    /// form phone number
                    CustomTextField(
                      prefixText: '     ',
                      prefixIcon: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey[300],
                          child: SvgPicture.asset(Assets.phoneActive)),
                      textEditingController:
                          signInProvider.phoneNumberController,
                      hintText: Utils.localization?.hint_phone,
                      validator: (value) => AppValidator.validateFields(
                          value, ValidationType.phone, context),
                    ),
                    const SizedBox(height: 20),

                    /// password

                    PasswordTextField(
                      controller: signInProvider.passController,
                    ),
                    const SizedBox(
                      height: 30,
                    ),

                    /// sign button
                    CustomButton(
                      width: double.infinity,
                      height: 46,
                      onPressed: () => context
                          .read<SignInProvider>()
                          .signIn(context: context),
                      child: CustomText(
                        Utils.localization?.login ?? "",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// Create new account
                    CustomButton(
                      width: double.infinity,
                      borderColor: Colors.red,
                      height: 46,
                      color: Colors.white,
                      onPressed: () {
                        context.pushNamed(RouteStrings.signUpPage);
                      },
                      child: Text(
                        Utils.localization?.createNewAccount ?? "",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                    const SizedBox(height: 30),

                    /// text forget account data
                    GestureDetector(
                      onTap: () {
                        context.pushNamed(RouteStrings.recoverAccount);
                      },
                      child: Center(
                        child: CustomText(
                          Utils.localization?.forgetYourData ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// language button changes
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // en button
                          CustomButton(
                            width: 100,
                            height: 40,
                            borderRadius: 4,
                            borderColor: !Utils.isRTL
                                ? AppColors.mainApp
                                : AppColors.notActive,
                            color: !Utils.isRTL
                                ? Colors.white
                                : AppColors.notActive,
                            onPressed: () => context
                                .read<SplashProvider>()
                                .saveLanguage('en'),
                            child: Text(
                              Utils.localization?.english_lang ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                      fontSize: 20,
                                      color: !Utils.isRTL
                                          ? AppColors.mainApp
                                          : Colors.grey),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),

                          // ar button
                          CustomButton(
                            height: 40,
                            width: 100,
                            borderRadius: 4,
                            borderColor: Utils.isRTL
                                ? AppColors.mainApp
                                : AppColors.notActive,
                            color: Utils.isRTL
                                ? Colors.white
                                : AppColors.notActive,
                            onPressed: () => context
                                .read<SplashProvider>()
                                .saveLanguage('ar'),
                            child: CustomText(
                              Utils.localization?.arabic_lang,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                      fontSize: 20,
                                      color: Utils.isRTL
                                          ? AppColors.mainApp
                                          : Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: CustomText(
                        Utils.localization?.signUpWithSocialMedia,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          Assets.facebook,
                          width: 50,
                          height: 50,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Image.asset(
                          Assets.google,
                          width: 50,
                          height: 50,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Image.asset(
                          Assets.twitter,
                          width: 50,
                          height: 50,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path0 = Path();
    path0.moveTo(0, size.height);
    path0.lineTo(size.width, size.height);
    path0.quadraticBezierTo(size.width * 0.9609041, size.height * -0.2992638,
        size.width * 0.6896164, size.height * 0.0802454);
    path0.quadraticBezierTo(
        size.width * 0.5270411, size.height * 0.2913497, 0, size.height);
    path0.close();

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
