// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:otlob_gas/common/constants/app_colors.dart';
import 'package:otlob_gas/common/constants/assets.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/checkout/presentation/provider/create_order_provider.dart';
import 'package:otlob_gas/widget/custom_button.dart';
import 'package:otlob_gas/widget/custom_text.dart';
import 'package:provider/provider.dart';

class ConfirmOrderDeliveredDialogWidget extends StatelessWidget {
  const ConfirmOrderDeliveredDialogWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final CreateOrderProvider createOrderProvider =
        context.read<CreateOrderProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        lottie.LottieBuilder.asset(Assets.confirmation),
        const SizedBox(height: 10.0),
        CustomText(
          Utils.localization?.please_confirm_delivery,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            CustomButton(
                elevation: 2,
                color: AppColors.mainApp,
                child: CustomText(
                  Utils.localization?.received,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                      ),
                ),
                onPressed: () {
                  createOrderProvider.toggleBetweenDeliveredAndCheck();
                }),
            const Spacer(),
            CustomButton(
                elevation: 2,
                color: AppColors.scaffoldColor,
                child: CustomText(
                  Utils.localization?.not_received,
                ),
                onPressed: () {
                  createOrderProvider.deliveredUnChecked();
                }),
          ],
        ),
      ],
    );
  }
}
