// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:otlob_gas/common/constants/assets.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/authentication/domain/entities/user_location.dart';
import 'package:otlob_gas/features/home/presentation/provider/manage_address_provider.dart';
import 'package:otlob_gas/widget/custom_app_bar.dart';
import 'package:provider/provider.dart';

import '../../../../common/constants/app_colors.dart';
import '../../../../common/constants/font_manager.dart';
import '../../../../common/constants/validator.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/custom_text_field.dart';

class ManageAddressPage extends StatefulWidget {
  const ManageAddressPage({
    Key? key,
    this.myLocation,
  }) : super(key: key);

  final UserLocation? myLocation;

  @override
  State<ManageAddressPage> createState() => _ManageAddressPageState();
}

class _ManageAddressPageState extends State<ManageAddressPage> {
  late final ManageAddressProvider manageAddressProvider =
      context.read<ManageAddressProvider>();
  late bool isEditAddress = widget.myLocation != null;
  @override
  void initState() {
    manageAddressProvider.init(widget.myLocation);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    manageAddressProvider.disposePage();
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
        isRootBack: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            /// top button
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        Assets.map,
                      ),
                      fit: BoxFit.cover)),
              child: Center(
                child: ElevatedButton(
                    style: Theme.of(context)
                        .elevatedButtonTheme
                        .style
                        ?.copyWith(
                          minimumSize: MaterialStateProperty.all<Size>(
                            const Size(250, 50),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          textStyle: MaterialStateProperty.all<TextStyle>(
                              const TextStyle(
                                  fontSize: 20,
                                  fontFamily: FontConstants.fontFamily)),
                        ),
                    onPressed: manageAddressProvider.selectLocation,
                    child: Text(
                      Utils.localization?.confirm_my_location ?? "",
                    )),
              ),
            ),

            const SizedBox(height: 10),

            /// text edit forms
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                key: manageAddressProvider.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          manageAddressProvider.buildingNumberController,
                      validator: (value) => AppValidator.validateFields(
                          value, ValidationType.notEmpty, context),
                    ),
                    const SizedBox(height: 40),

                    /// floor number
                    CustomText(
                      Utils.localization?.floor_number ?? "",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeightManger.regular),
                    ),
                    const SizedBox(height: 20),

                    /// floor number
                    CustomTextField(
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
                          manageAddressProvider.floorNumberController,
                      validator: (value) => AppValidator.validateFields(
                          value, ValidationType.notEmpty, context),
                    ),

                    const SizedBox(height: 40),

                    /// title
                    CustomText(
                      Utils.localization?.address_title ?? "",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeightManger.regular),
                    ),
                    const SizedBox(height: 20),

                    /// title
                    CustomTextField(
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
                          manageAddressProvider.titleController,
                      validator: (value) => AppValidator.validateFields(
                          value, ValidationType.notEmpty, context),
                    ),
                    const SizedBox(height: 20),
                    Consumer<ManageAddressProvider>(builder: (_, provider, __) {
                      return SwitchListTile(
                        title: CustomText(
                          Utils.localization?.is_default_address,
                        ),
                        onChanged: (bool value) {
                          provider.setIsDefault = value;
                        },
                        value: provider.isDefault,
                      );
                    }),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height / 36.6),

            // add or edit button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => isEditAddress
                    ? manageAddressProvider.editMyLocation(context,
                        locationId: widget.myLocation!.id!)
                    : manageAddressProvider.addMyLocation(context),
                style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                    minimumSize: MaterialStateProperty.all<Size>(
                      const Size(double.infinity, 50),
                    ),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(
                            fontSize: 25,
                            fontFamily: FontConstants.fontFamily)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero))),
                child: Text(isEditAddress
                    ? Utils.localization!.edit_address
                    : Utils.localization!.add_address),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
