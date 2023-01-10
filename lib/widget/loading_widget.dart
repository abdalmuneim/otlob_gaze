// 🎯 Dart imports:

// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:otlob_gas/common/constants/app_colors.dart';
import 'package:otlob_gas/common/constants/assets.dart';
import 'package:otlob_gas/widget/custom_text.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key, this.description}) : super(key: key);

  final String? description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset(Assets.loading, height: 200),
            if (description != null) ...[
              const SizedBox(height: 10.0),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(0, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: CustomText(
                    description,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(color: AppColors.mainApp, fontSize: 22),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
