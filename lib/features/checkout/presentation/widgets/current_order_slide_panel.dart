import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otlob_gas/common/constants/app_colors.dart';
import 'package:otlob_gas/common/constants/assets.dart';
import 'package:otlob_gas/common/constants/font_manager.dart';
import 'package:otlob_gas/common/constants/navigator_utils.dart';
import 'package:otlob_gas/common/extensions.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/checkout/presentation/provider/create_order_provider.dart';
import 'package:otlob_gas/widget/custom_button.dart';
import 'package:otlob_gas/widget/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CurrentOrderSlidePanel extends StatelessWidget {
  const CurrentOrderSlidePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final CreateOrderProvider createOrderProvider =
        context.read<CreateOrderProvider>();
    return SlidingUpPanel(
      isDraggable: true,
      minHeight: MediaQuery.of(context).size.height * 0.25,
      maxHeight: MediaQuery.of(context).size.height * 0.35,
      color: Colors.white,
      header: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: [
          Container(
            height: 30,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(13),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  decoration: BoxDecoration(
                      color: AppColors.notActive,
                      borderRadius: BorderRadius.circular(20)),
                ),
              ],
            ),
          ),
        ],
      ),
      panel: Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          color: Colors.white,
          child: Selector<CreateOrderProvider, int>(
              selector: (_, provider) => provider.order!.status!,
              builder: (_, status, __) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    Selector<CreateOrderProvider, String>(
                        selector: (_, provider) => provider.order?.time ?? '0',
                        builder: (_, arriveTime, __) {
                          // if order accepted
                          // if (status == 1)
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                arriveTime == '0' && status == 6
                                    ? Assets.orderDoneIC
                                    : Assets.clockBlueIC,
                                width: 30,
                              ),
                              const SizedBox(width: 10),
                              CustomText(
                                arriveTime == '0' && status == 6
                                    ? Utils.localization?.order_received
                                    : Utils.localization
                                        ?.arrive_minute(int.parse(arriveTime)),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                      fontWeight: FontWeightManger.medium,
                                      color: arriveTime == '0' && status == 6
                                          ? Colors.red
                                          : AppColors.mainApp,
                                      fontSize: 25,
                                    ),
                              ),
                            ],
                          );
                        }),

                    const SizedBox(height: 10),
                    Container(
                        height: 1,
                        color: Colors.grey[400],
                        width: double.infinity),
                    const SizedBox(height: 20),

                    /// number of gas cylinder ordered
                    Row(
                      children: [
                        SvgPicture.asset(Assets.carBlueIC),
                        const SizedBox(
                          width: 10,
                        ),
                        CustomText(
                          Utils.localization?.number_gas_cylinder,
                        ),
                        const Spacer(),

                        //   number of cylinder required
                        CustomText(
                          '${createOrderProvider.order!.quantity!}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                fontWeight: FontWeightManger.regular,
                                color: AppColors.mainApp,
                                fontSize: 20,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                        height: 1,
                        color: Colors.grey[400],
                        width: double.infinity),
                    const SizedBox(height: 20),

                    /// delivery cost
                    Row(
                      children: [
                        SvgPicture.asset(Assets.reciteBlueIC),
                        const SizedBox(width: 10),
                        CustomText(
                          Utils.localization?.delivery_cost,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                fontWeight: FontWeightManger.regular,
                                color: AppColors.mainApp,
                                fontSize: 20,
                              ),
                        ),
                        const Spacer(),
                        CustomText(
                          createOrderProvider.deliveryCost.toPrice,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                fontWeight: FontWeightManger.regular,
                                color: AppColors.mainApp,
                                fontSize: 20,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    /// chat with me button
                    Row(
                      children: [
                        Expanded(
                            child: CustomButton(
                          onPressed: () {
                            NavigatorUtils.goToChatWithDriver(
                                createOrderProvider.order!.id!);
                          },
                          height: 45,
                          color: AppColors.mainApp,
                          child: Text(
                            Utils.localization?.connect_me ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(
                                  fontWeight: FontWeightManger.regular,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                          ),
                        )),

                        // if order is not accepted show these buttons
                        if (status != 2) ...[
                          const SizedBox(width: 10),

                          /// received button
                          Expanded(
                              child: CustomButton(
                            onPressed: () {
                              createOrderProvider
                                  .toggleBetweenDeliveredAndCheck();
                            },
                            height: 45,
                            color: Colors.green,
                            child: Text(
                              Utils.localization?.received ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                    fontWeight: FontWeightManger.regular,
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                            ),
                          )),
                          const SizedBox(width: 10),

                          /// cancel button
                          Expanded(
                              child: CustomButton(
                            onPressed: () {
                              createOrderProvider.cancelOrder();
                            },
                            height: 45,
                            color: Colors.red,
                            child: Text(
                              Utils.localization?.cancel ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                    fontWeight: FontWeightManger.regular,
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                            ),
                          )),
                        ],
                      ],
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                  ],
                );
              })),
    );
  }
}
