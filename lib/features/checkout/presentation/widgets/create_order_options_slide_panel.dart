import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otlob_gas/common/constants/app_colors.dart';
import 'package:otlob_gas/common/constants/assets.dart';
import 'package:otlob_gas/common/constants/font_manager.dart';
import 'package:otlob_gas/common/extensions.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/checkout/presentation/provider/create_order_provider.dart';
import 'package:otlob_gas/widget/custom_button.dart';
import 'package:otlob_gas/widget/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CreateOrderOptionsSlidePanel extends StatelessWidget {
  const CreateOrderOptionsSlidePanel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CreateOrderProvider createOrderProvider =
        context.read<CreateOrderProvider>();
    return SlidingUpPanel(
      isDraggable: true,
      minHeight: MediaQuery.of(context).size.height * 0.3,
      maxHeight: MediaQuery.of(context).size.height * 0.45,
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
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(20)),
                ),
              ],
            ),
          ),
        ],
      ),
      panel: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            color: Colors.white,
            child: Selector<CreateOrderProvider,
                    dartz.Tuple3<bool, String, double>>(
                selector: (_, provider) => dartz.Tuple3(
                    provider.isCash, provider.count, provider.deliveryCost),
                builder: (_, selectorProvider, __) {
                  final bool isCash = selectorProvider.value1;
                  final bool isWallet = !isCash;
                  final String count = selectorProvider.value2;
                  final double deliveryCost = selectorProvider.value3;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 39,
                      ),

                      /// number of Gas cylinder
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                  width: 50,
                                  height: 50,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.mainApp),
                                  child: Image.asset(Assets.ambobaIC)),
                              const SizedBox(width: 10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    Utils.localization?.number_gas_cylinder,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(
                                            fontWeight:
                                                FontWeightManger.regular),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        createOrderProvider.changeCount(
                                            increase: true);
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border:
                                                Border.all(color: Colors.grey)),
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.grey,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    CustomText(
                                      count,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .copyWith(
                                              fontSize: 22, color: Colors.grey),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        createOrderProvider.changeCount(
                                            increase: false);
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border:
                                                Border.all(color: Colors.grey)),
                                        child: const Icon(
                                          Icons.remove,
                                          color: Colors.grey,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(height: 10, thickness: 1),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// payment - cash
                          Row(
                            children: [
                              CupertinoSwitch(
                                value: isCash,
                                activeColor: AppColors.mainApp,
                                onChanged: (bool value) {
                                  createOrderProvider.setCashSwitch = value;
                                },
                              ),
                              CustomText(
                                Utils.localization?.pay_cash,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(fontSize: 18),
                              )
                            ],
                          ),

                          /// payment - wallet
                          Row(
                            children: [
                              CupertinoSwitch(
                                value: isWallet,
                                activeColor: AppColors.mainApp,
                                onChanged: (bool value) {
                                  createOrderProvider.setCashSwitch = !value;
                                },
                              ),
                              CustomText(
                                Utils.localization?.wallet ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(fontSize: 18),
                              )
                            ],
                          ),
                        ],
                      ),

                      const Divider(height: 10, thickness: 1),

                      /// number  of Gas cylinder needed

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(Assets.carBlueIC),
                                const SizedBox(width: 10),
                                CustomText(
                                  Utils.localization?.number_gas_cylinder,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(fontSize: 18),
                                ),
                              ],
                            ),
                            CustomText(
                              count,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                      fontSize: 18, color: AppColors.mainApp),
                            ),
                          ],
                        ),
                      ),

                      /// your wallet balance
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(Assets.circleRedDollarIC),
                                const SizedBox(width: 10),
                                CustomText(
                                  Utils.localization?.your_wallet_balance ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(
                                          fontSize: 18, color: Colors.red),
                                ),
                              ],
                            ),
                            CustomText(
                              createOrderProvider.wallet?.toPrice,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(fontSize: 18, color: Colors.red),
                            ),
                          ],
                        ),
                      ),

                      const Divider(height: 10, thickness: 1),

                      /// delivery cost
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
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
                                          fontSize: 18,
                                          color: AppColors.mainApp),
                                ),
                              ],
                            ),
                            CustomText(
                              deliveryCost.toPrice,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                      fontSize: 18, color: AppColors.mainApp),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
          ),
          CustomButton(
            onPressed: () => createOrderProvider.submitOrder(),
            height: 45,
            borderRadius: 0,
            width: double.infinity,
            color: AppColors.mainApp,
            child: CustomText(
              Utils.localization?.confirm_order,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 25, fontFamily: FontConstants.fontFamily),
            ),
          ),
        ],
      ),
    );
  }
}
