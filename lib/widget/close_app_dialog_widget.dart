import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:otlob_gas/common/constants/app_colors.dart';
import 'package:otlob_gas/common/constants/assets.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/home/presentation/provider/pages_handler_provider.dart';
import 'package:otlob_gas/widget/custom_button.dart';
import 'package:otlob_gas/widget/custom_text.dart';

class CloseAppDialogWidget extends StatelessWidget {
  const CloseAppDialogWidget({
    Key? key,
    required this.pagesHandlerProvider,
  }) : super(key: key);
  static const String dialogName = 'exit';

  final PagesHandlerProvider pagesHandlerProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LottieBuilder.asset(Assets.menuClose),
        const SizedBox(height: 20.0),
        CustomText(Utils.localization?.do_you_want_to_exit_the_app),
        const SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
                elevation: 2,
                color: AppColors.mainApp,
                child: CustomText(
                  Utils.localization?.cancel,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                      ),
                ),
                onPressed: () {
                  Utils.hideCustomDialog(name: dialogName);
                }),
            const SizedBox(width: 20.0),
            CustomButton(
                elevation: 2,
                color: AppColors.scaffoldColor,
                child: CustomText(
                  Utils.localization?.exit,
                ),
                onPressed: () async {
                  await pagesHandlerProvider.changeUserActivity(
                      isActive: false);
                  await pagesHandlerProvider.disposePage();
                  exit(0);
                }),
          ],
        ),
      ],
    );
  }
}
