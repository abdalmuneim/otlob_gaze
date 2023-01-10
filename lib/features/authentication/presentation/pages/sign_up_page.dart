import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:otlob_gas/common/constants/app_colors.dart';
import 'package:otlob_gas/common/constants/font_manager.dart';
import 'package:otlob_gas/common/constants/strings.dart';
import 'package:otlob_gas/common/constants/validator.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/authentication/presentation/provider/auth_provider.dart';
import 'package:otlob_gas/features/authentication/presentation/provider/sign_up_provider.dart';
import 'package:otlob_gas/features/authentication/presentation/widgets/password_text_field.dart';
import 'package:otlob_gas/features/on_boarding/presentation/provider/splash_provider.dart';
import 'package:otlob_gas/widget/custom_button.dart';
import 'package:otlob_gas/widget/custom_text.dart';
import 'package:otlob_gas/widget/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:search_map_location/utils/google_search/geo_location.dart';
import 'package:search_map_location/utils/google_search/latlng.dart';

import '../../../../common/constants/assets.dart';
import '../../../../widget/search_location.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key, this.isEdit = false}) : super(key: key);
  final bool isEdit;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late final SignUpProvider signUpProvider = context.read<SignUpProvider>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    signUpProvider.initPage(widget.isEdit);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    signUpProvider.disposePage();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.copyWith(
              bodySmall: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(fontWeight: FontWeightManger.medium),
              headlineSmall: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.grey),
            ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: CustomText(
            (widget.isEdit
                    ? Utils.localization?.data_modification
                    : Utils.localization?.createAccount) ??
                "",
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontWeight: FontWeightManger.bold, color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: signUpProvider.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10.0),

                    GestureDetector(
                      onTap: signUpProvider.pickPicture,
                      child: Consumer<SignUpProvider>(
                        builder: (_, signUpProvider, __) => Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 110,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 5.0),
                                    if (signUpProvider
                                            .currentUser?.imageForWeb !=
                                        null)
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(500),
                                        child: CachedNetworkImage(
                                          imageUrl: signUpProvider
                                              .currentUser!.imageForWeb!,
                                          fit: BoxFit.cover,
                                          height: 60,
                                          width: 60,
                                        ),
                                      )
                                    else if (signUpProvider.selectedImage !=
                                        null)
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(500),
                                        child: Image.file(
                                          signUpProvider.selectedImage!,
                                          fit: BoxFit.cover,
                                          height: 60,
                                          width: 60,
                                        ),
                                      )
                                    else
                                      SvgPicture.asset(
                                        Assets.userIC,
                                        height: 50,
                                      ),
                                    const SizedBox(height: 10.0),
                                    CustomText(
                                      Utils.localization
                                          ?.select_a_profile_picture,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            color: AppColors.mainApp,
                                          ),
                                    ),
                                    const SizedBox(height: 5.0),
                                  ],
                                ),
                              ),
                            ),
                            if (!signUpProvider.isValidImage) ...[
                              const SizedBox(height: 10.0),
                              CustomText(
                                Utils.localization?.please_fill_this_field,
                                textAlign: TextAlign.start,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: Colors.red,
                                    ),
                              ),
                            ]
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    /// txt name
                    CustomText(Utils.localization?.fullName),
                    const SizedBox(height: 10),

                    /// form name
                    CustomTextField(
                        prefixText: '     ',
                        prefixIcon: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.grey[300],
                            child: SvgPicture.asset(Assets.bottPersonIC)),
                        textEditingController: signUpProvider.nameController,
                        validator: (value) => AppValidator.validateFields(
                            value, ValidationType.name, context),
                        hintText: Utils.localization?.name ?? ""),
                    const SizedBox(height: 20),

                    /// phone number
                    CustomText(Utils.localization?.phoneNumber),
                    const SizedBox(height: 10),

                    /// form phone number
                    CustomTextField(
                      prefixText: '     ',
                      prefixIcon: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey[300],
                          child: SvgPicture.asset(Assets.phoneActive)),
                      textEditingController:
                          signUpProvider.mobileAddressController,
                      hintText: Utils.localization?.hint_phone,
                      validator: (value) => AppValidator.validateFields(
                          value, ValidationType.phone, context),
                    ),
                    const SizedBox(height: 20),

                    /// text mail
                    CustomText(Utils.localization?.mail),
                    const SizedBox(height: 10),

                    /// form email
                    CustomTextField(
                      readOnly: widget.isEdit,
                      prefixText: '     ',
                      prefixIcon: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey[300],
                          child: SvgPicture.asset(
                            Assets.messagesIC,
                            height: 20,
                          )),
                      hintText: Utils.localization?.hint_email,
                      textEditingController:
                          signUpProvider.emailAddressController,
                      validator: (value) => AppValidator.validateFields(
                          value, ValidationType.email, context),
                    ),
                    const SizedBox(height: 20),

                    /// text password
                    CustomText(Utils.localization?.pass),
                    const SizedBox(height: 10),

                    /// form password
                    PasswordTextField(
                      controller: signUpProvider.passController,
                      isEditMode: widget.isEdit,
                    ),

                    const SizedBox(height: 20),

                    /// text confirm password
                    CustomText(Utils.localization?.confirmPass),
                    const SizedBox(height: 10),

                    /// form confirm password
                    PasswordTextField(
                      controller: signUpProvider.confirmPasswordController,
                      isEditMode: widget.isEdit,
                    ),

                    const SizedBox(height: 20),

                    /// address text
                    CustomText(Utils.localization?.location),
                    const SizedBox(height: 10),

                    /// form address
                    Consumer<SignUpProvider>(builder: (_, signUpProvider, __) {
                      return SearchLocation(
                        scrollController: _scrollController,
                        validator: (value) {
                          if (!signUpProvider.isValidCords) {
                            return Utils.localization?.validate_location ?? '';
                          }
                          return null;
                        },
                        //reset coordinates so the user can't proceed in sign up because he should choose a valid address from google map
                        onClearIconPress: signUpProvider.resetCords,
                        onChangeText: (_) => signUpProvider.resetCords(),

                        language: context.read<SplashProvider>().language,
                        location: LatLng(
                            latitude: signUpProvider.lat ?? 0,
                            longitude: signUpProvider.long ?? 0),
                        textEditingController: signUpProvider.addressController,
                        radius: 1100,
                        prefixText: '     ',
                        placeholder: Utils.localization?.hint_dash ?? "",
                        apiKey: Strings.googleMapApiKey,
                        onSelected: (value) async {
                          // value.geolocation
                          final Geolocation? geo = await value.geolocation;
                          final LatLng cord = geo!.coordinates;
                          signUpProvider.getAddressByGeoLocation(
                            cord.latitude,
                            cord.longitude,
                          );
                        },
                      );
                    }),
                    const SizedBox(
                      height: 30,
                    ),

                    /// get location button
                    CustomButton(
                      height: 50,
                      borderColor: AppColors.mainApp,
                      color: Colors.white,
                      onPressed: () => signUpProvider.determinePosition(),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              Assets.locationOutlinedIC,
                              color: AppColors.mainApp,
                            ),
                            const SizedBox(width: 10),
                            CustomText(
                              Utils.localization?.give_location_access,
                              style: const TextStyle(
                                  fontSize: 18, color: AppColors.mainApp),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    ///Create Account button
                    CustomButton(
                      onPressed: () => widget.isEdit
                          ? signUpProvider.editAccount().then((_) =>
                              context.read<AuthProvider>().getCurrentUser())
                          : signUpProvider.signUp(),
                      height: 50,
                      width: double.infinity,
                      child: Text(
                        (widget.isEdit
                                ? Utils.localization?.updateAccount
                                : Utils.localization?.create_the_account) ??
                            "",
                        style:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeightManger.medium,
                                ),
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
