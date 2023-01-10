import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:otlob_gas/common/constants/app_colors.dart';
import 'package:otlob_gas/common/constants/assets.dart';
import 'package:otlob_gas/common/constants/font_manager.dart';
import 'package:otlob_gas/common/routes/route_strings.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/home/presentation/provider/profile_page_provider.dart';
import 'package:otlob_gas/features/home/presentation/widgets/mobile_number_widget.dart';
import 'package:otlob_gas/features/home/presentation/widgets/profile_app_bar.dart';
import 'package:otlob_gas/widget/custom_button.dart';
import 'package:otlob_gas/widget/custom_cached_image.dart';
import 'package:otlob_gas/widget/custom_text.dart';
import 'package:otlob_gas/widget/loading_widget.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ProfilePageProvider profilePageProvider =
      context.read<ProfilePageProvider>();
  @override
  void initState() {
    profilePageProvider.getOrderStatus();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ProfileAppBar(),
      body:
          Consumer<ProfilePageProvider>(builder: (_, profilePageProvider, __) {
        if (profilePageProvider.isLoading) {
          return const LoadingWidget();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            CircleAvatar(
              radius: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CustomCachedNetworkImage(
                  url: profilePageProvider.currentUser?.imageForWeb,
                  boxFit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            CustomText(
              profilePageProvider.currentUser?.name,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeightManger.bold,
                    color: Colors.black,
                  ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MobileNumberWidget(
                  mobile: profilePageProvider.currentUser?.mobile,
                  color: Colors.black,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  Assets.messagesIC,
                  color: Colors.black,
                  height: 17,
                ),
                const SizedBox(
                  width: 10,
                ),
                CustomText(
                  profilePageProvider.currentUser?.email,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  Assets.locationOutlinedIC,
                  color: AppColors.lightRed,
                ),
                const SizedBox(
                  width: 10,
                ),
                CustomText(
                  profilePageProvider.currentUser?.address,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Material(
                borderRadius: BorderRadius.circular(5),
                elevation: 2,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          CustomText(Utils.localization?.totalOrders,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                    fontWeight: FontWeightManger.regular,
                                    fontSize: 25,
                                  )),
                          CustomText(
                              profilePageProvider.orderStatus.totalOrder
                                  .toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                      fontWeight: FontWeightManger.bold,
                                      color: AppColors.mainApp,
                                      fontSize: 30)),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          CustomText(Utils.localization?.todaysOrders,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                    fontWeight: FontWeightManger.regular,
                                    fontSize: 25,
                                  )),
                          CustomText(
                              profilePageProvider.orderStatus.orderToday
                                  .toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                      fontWeight: FontWeightManger.bold,
                                      color: AppColors.mainApp,
                                      fontSize: 30)),
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: CustomButton(
                onPressed: () =>
                    context.pushNamed(RouteStrings.editAccountPage),
                width: double.infinity,
                child: CustomText(
                  Utils.localization?.updateAccount,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ),
            const SizedBox(height: kBottomNavigationBarHeight + 10.0),
          ],
        );
      }),
    );
  }
}
