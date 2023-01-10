import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:otlob_gas/common/constants/app_colors.dart';
import 'package:otlob_gas/common/constants/assets.dart';
import 'package:otlob_gas/common/routes/route_strings.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/authentication/domain/entities/user.dart';
import 'package:otlob_gas/features/authentication/presentation/provider/auth_provider.dart';
import 'package:otlob_gas/features/home/presentation/provider/pages_handler_provider.dart';
import 'package:otlob_gas/widget/custom_button.dart';
import 'package:otlob_gas/widget/custom_text.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final PagesHandlerProvider pagesHandlerProvider =
        context.read<PagesHandlerProvider>();
    late final User currentUser =
        context.read<AuthProvider>().currentUser ?? const User();
    return Theme(
      data: Theme.of(context).copyWith(
          textTheme: Theme.of(context).textTheme.copyWith(
              bodySmall: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(fontSize: 25))),
      child: Drawer(
        child: ListView(children: [
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(500),
              child: CachedNetworkImage(
                imageUrl: currentUser.imageForWeb ?? currentUser.image ?? '',
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
            ),
            title: CustomText(
              currentUser.name,
              max: 1,
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(color: AppColors.mainApp, fontSize: 22),
            ),
            subtitle: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  Assets.phoneActive,
                  height: 15,
                  color: Colors.black,
                ),
                const SizedBox(width: 10.0),
                CustomText(
                  currentUser.mobile,
                  max: 1,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.black, fontSize: 20),
                ),
              ],
            ),
          ),
          ListTile(
            leading: SvgPicture.asset(Assets.homeBlueIC),
            title: CustomText(Utils.localization?.homePage),
            onTap: () {
              pagesHandlerProvider.setIndex = 0;
            },
          ),
          ListTile(
            leading: SvgPicture.asset(Assets.userIC, height: 25),
            title: CustomText(Utils.localization?.profile),
            onTap: () {
              pagesHandlerProvider.setIndex = 3;
            },
          ),
          ListTile(
            leading: SvgPicture.asset(Assets.editBlueIC),
            title: CustomText(Utils.localization?.updateAccount),
            onTap: () => context.pushNamed(RouteStrings.editAccountPage),
          ),
          ListTile(
            leading: SvgPicture.asset(Assets.listOrderBlueIC),
            title: CustomText(Utils.localization?.order_list),
            onTap: () {
              pagesHandlerProvider.setIndex = 1;
            },
          ),
          ListTile(
            leading: SvgPicture.asset(Assets.accountBalanceIC),
            title: CustomText(Utils.localization?.wallet),
            onTap: () {
              pagesHandlerProvider.setIndex = 4;
            },
          ),
          ListTile(
            onTap: () {
              context.pushNamed(RouteStrings.privacy);
            },
            leading: const Icon(
              Icons.privacy_tip_outlined,
              color: AppColors.mainApp,
              size: 30,
            ),
            title: CustomText(Utils.localization?.privacy_policy),
          ),
          ListTile(
            onTap: () {
              context.pushNamed(RouteStrings.terms);
            },
            leading: const Icon(
              Icons.article_outlined,
              color: AppColors.mainApp,
              size: 30,
            ),
            title: CustomText(Utils.localization?.terms_conditions),
          ),
          ListTile(
            onTap: () {
              context.pushNamed(RouteStrings.aboutApp);
            },
            leading: SvgPicture.asset(Assets.infoBlueIC),
            title: CustomText(Utils.localization?.about_app),
          ),
          /*   ListTile(
            leading: SvgPicture.asset(Assets.settingBlueIC),
            title: CustomText(Utils.localization?.app_setting),
          ), */
          ListTile(
            leading: SvgPicture.asset(Assets.logOutRedIC),
            title: CustomText(Utils.localization?.logout),
            onTap: () {
              const dialogName = 'logout';
              Utils.showCustomDialog(
                borderRadius: BorderRadius.circular(10),
                name: dialogName,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(Utils.localization?.logout),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomButton(
                          onPressed: () {
                            pagesHandlerProvider.scaffoldKey.currentState!
                                .closeDrawer();
                            context.read<AuthProvider>().logout();
                          },
                          color: Colors.red,
                          child: CustomText(
                            Utils.localization?.yes,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        CustomButton(
                          onPressed: () {
                            pagesHandlerProvider.scaffoldKey.currentState!
                                .closeDrawer();
                            Utils.hideCustomDialog(name: dialogName);
                          },
                          color: AppColors.mainApp,
                          child: CustomText(
                            Utils.localization?.no,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ]),
      ),
    );
  }
}
