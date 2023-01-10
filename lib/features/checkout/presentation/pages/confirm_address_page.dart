import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:otlob_gas/common/constants/assets.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/authentication/domain/entities/user_location.dart';
import 'package:otlob_gas/features/checkout/presentation/provider/confirm_address_provider.dart';
import 'package:otlob_gas/widget/custom_app_bar.dart';
import 'package:provider/provider.dart';

import '../../../../common/constants/app_colors.dart';
import '../../../../common/constants/font_manager.dart';
import '../../../../common/constants/validator.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/custom_text_field.dart';

class ConfirmAddressPage extends StatefulWidget {
  const ConfirmAddressPage({
    Key? key,
    required this.myLocation,
  }) : super(key: key);

  final UserLocation myLocation;

  @override
  State<ConfirmAddressPage> createState() => _ConfirmAddressPageState();
}

class _ConfirmAddressPageState extends State<ConfirmAddressPage> {
  late final ConfirmAddressProvider confirmAddressProvider =
      context.read<ConfirmAddressProvider>();

  @override
  void initState() {
    confirmAddressProvider.init(widget.myLocation);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    confirmAddressProvider.disposePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: const SizedBox(),
        title: Text(
          Utils.localization!.confirm_address,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeightManger.bold,
                color: Colors.white,
                fontSize: 22,
              ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            /// text edit forms
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  CustomText(
                    Utils.localization?.address_title ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeightManger.regular),
                  ),
                  const SizedBox(height: 20),

                  /// building number
                  CustomTextField(
                    readOnly: true,
                    prefixText: '     ',
                    prefixIcon: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey[300],
                        child: SvgPicture.asset(
                          Assets.locationOutlinedIC,
                          color: AppColors.mainApp,
                        )),
                    hintText: Utils.localization?.hint_dash ?? "",
                    textEditingController:
                        confirmAddressProvider.titleController,
                    validator: (value) => AppValidator.validateFields(
                        value, ValidationType.notEmpty, context),
                  ),
                  const SizedBox(height: 20),

                  CustomText(
                    Utils.localization?.building_number ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeightManger.regular),
                  ),
                  const SizedBox(height: 20),

                  /// building number
                  CustomTextField(
                    readOnly: true,
                    prefixText: '     ',
                    prefixIcon: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey[300],
                        child: SvgPicture.asset(
                          Assets.locationOutlinedIC,
                          color: AppColors.mainApp,
                        )),
                    hintText: Utils.localization?.hint_dash ?? "",
                    textEditingController:
                        confirmAddressProvider.buildingNumberController,
                    validator: (value) => AppValidator.validateFields(
                        value, ValidationType.notEmpty, context),
                  ),
                  const SizedBox(height: 20),

                  /// floor number
                  CustomText(
                    Utils.localization?.floor_number ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeightManger.regular),
                  ),
                  const SizedBox(height: 20),

                  /// building number
                  CustomTextField(
                    readOnly: true,
                    prefixText: '     ',
                    prefixIcon: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey[300],
                        child: SvgPicture.asset(
                          Assets.locationOutlinedIC,
                          color: AppColors.mainApp,
                        )),
                    hintText: Utils.localization?.hint_dash ?? "",
                    textEditingController:
                        confirmAddressProvider.floorNumberController,
                    validator: (value) => AppValidator.validateFields(
                        value, ValidationType.notEmpty, context),
                  ),
                  const SizedBox(height: 20),

                  /// notes text for driver
                  CustomText(
                    Utils.localization?.nots_to_drive ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeightManger.regular),
                  ),
                  const SizedBox(height: 20),

                  /// notes for driver text form filed
                  CustomTextField(
                    isMultiLine: true,
                    prefixText: '     ',
                    prefixIcon: SizedBox(
                      width: 20,
                      height: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(Assets.attentionsIC,
                                color: Colors.grey),
                          ),
                          Container(),
                        ],
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 35,
                      minHeight: 0,
                    ),
                    hintText: Utils.localization?.hint_dash ?? "",
                    textEditingController:
                        confirmAddressProvider.driverNotesController,
                    validator: (value) => AppValidator.validateFields(
                        value, ValidationType.notEmpty, context),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.0471),

            /// bottom content

            Container(
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    blurRadius: 7,
                    color: Colors.grey.withOpacity(0.5),
                    offset: const Offset(0, 1))
              ]),
              height: 130,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  /// number of Gas cylinder
                  Container(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// order data
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
                                          fontWeight: FontWeightManger.regular),
                                ),
                              ],
                            ),
                          ],
                        ),

                        /// button counter
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
                                      confirmAddressProvider.changeCount(
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
                                  Selector<ConfirmAddressProvider, String>(
                                      selector: (_, confirmAddressProvider) =>
                                          confirmAddressProvider.count,
                                      builder: (_, count, __) {
                                        return CustomText(
                                          count,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .copyWith(
                                                  fontSize: 22,
                                                  color: Colors.grey),
                                        );
                                      }),
                                  InkWell(
                                    onTap: () {
                                      confirmAddressProvider.changeCount(
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
                  ),
                  const SizedBox(height: 10),

                  // confirm order button
                  ElevatedButton(
                    onPressed: () => confirmAddressProvider.goToCreateOrder(),
                    style: Theme.of(context)
                        .elevatedButtonTheme
                        .style
                        ?.copyWith(
                            minimumSize: MaterialStateProperty.all<Size>(
                              const Size(double.infinity, 50),
                            ),
                            textStyle: MaterialStateProperty.all<TextStyle>(
                                const TextStyle(
                                    fontSize: 25,
                                    fontFamily: FontConstants.fontFamily)),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero))),
                    child: Text(Utils.localization!.continue_),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
