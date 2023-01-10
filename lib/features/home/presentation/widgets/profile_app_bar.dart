import 'package:flutter/material.dart';
import 'package:otlob_gas/common/constants/font_manager.dart';
import 'package:otlob_gas/features/authentication/domain/entities/user.dart';
import 'package:otlob_gas/features/authentication/presentation/provider/auth_provider.dart';
import 'package:otlob_gas/features/home/presentation/widgets/mobile_number_widget.dart';
import 'package:otlob_gas/widget/custom_app_bar.dart';
import 'package:otlob_gas/widget/custom_cached_image.dart';
import 'package:otlob_gas/widget/custom_text.dart';
import 'package:otlob_gas/widget/drawer_icon.dart';
import 'package:otlob_gas/widget/notification_button_widget.dart';
import 'package:provider/provider.dart';

class ProfileAppBar extends StatelessWidget with PreferredSizeWidget {
  const ProfileAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 5);

  @override
  Widget build(BuildContext context) {
    return Selector<AuthProvider, User>(
        selector: (_, provider) => provider.currentUser ?? const User(),
        builder: (_, currentUser, __) {
          return CustomAppBar(
            toolbarHeight: preferredSize.height,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  currentUser.name,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeightManger.bold, color: Colors.white),
                ),
                const SizedBox(
                  height: 1,
                ),
                MobileNumberWidget(mobile: currentUser.mobile),
              ],
            ),
            actions: const [
              NotificationButton(),
              SizedBox(width: 10),
              DrawerIcon(),
              SizedBox(width: 10),
            ],
            leading: Container(
              margin: const EdgeInsets.only(right: 10),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: CustomCachedNetworkImage(
                url: currentUser.imageForWeb,
                boxFit: BoxFit.cover,
              ),
            ),
          );
        });
  }
}
