import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:otlob_gas/common/constants/app_colors.dart';
import 'package:otlob_gas/common/constants/assets.dart';
import 'package:otlob_gas/common/constants/navigator_utils.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/authentication/domain/entities/user_location.dart';
import 'package:otlob_gas/features/authentication/presentation/provider/auth_provider.dart';
import 'package:otlob_gas/features/home/presentation/provider/home_provider.dart';
import 'package:otlob_gas/widget/custom_app_bar.dart';
import 'package:otlob_gas/widget/custom_button.dart';
import 'package:otlob_gas/widget/custom_text.dart';
import 'package:otlob_gas/widget/drawer_icon.dart';
import 'package:otlob_gas/widget/loading_widget.dart';
import 'package:otlob_gas/widget/notification_button_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  late final HomeProvider homeProvider = context.read<HomeProvider>();
  initHome() async {
    await homeProvider.initHome(context);
  }

  init() async {
    await context.read<AuthProvider>().getCurrentUser();

    await initHome();
    isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.notActive,
      appBar: CustomAppBar(
        title: CustomText(
          Utils.localization?.homePage,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: Colors.white),
        ),
        actions: const [
          NotificationButton(),
          SizedBox(
            width: 10,
          ),
          DrawerIcon(),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: isLoading
          ? const LoadingWidget()
          : Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 150,
                  child: homeProvider.ads.isEmpty
                      ? Center(
                          child: CustomText(
                            Utils.localization?.bannersArea,
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                        )
                      : CarouselSlider(
                          options: CarouselOptions(
                            autoPlay: true,
                            viewportFraction: 1,
                          ),
                          items: homeProvider.ads.map((i) {
                            return GestureDetector(
                              onTap: () => homeProvider.launchLink(i.link!),
                              child: CachedNetworkImage(
                                imageUrl: i.imageForWeb ?? '',
                                fit: BoxFit.cover,
                              ),
                            );
                          }).toList(),
                        ),
                ),
                DecoratedBox(
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SizedBox(
                          height: 100,
                          child: Consumer<HomeProvider>(
                              builder: (_, homeProvider, __) {
                            return ListView.separated(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              itemBuilder: (context, index) {
                                final UserLocation myLocation =
                                    homeProvider.myLocations[index];
                                return DecoratedBox(
                                  decoration: BoxDecoration(
                                      color: homeProvider.indexAddress == index
                                          ? Colors.blue.withOpacity(0.2)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(7),
                                      border: homeProvider.indexAddress != index
                                          ? null
                                          : Border.all(
                                              color: Colors.grey.shade400)),
                                  child: ListTile(
                                    visualDensity: const VisualDensity(
                                        vertical: -4, horizontal: -4),
                                    title: CustomText(
                                      myLocation.title,
                                    ),
                                    leading: SvgPicture.asset(
                                        Assets.locationFilledIC),
                                    trailing: IconButton(
                                      onPressed: () async {
                                        homeProvider.upsertLocation =
                                            await NavigatorUtils
                                                .goToManageAddress(
                                                    myLocation: homeProvider
                                                        .myLocations[index]);
                                      },
                                      icon: const Icon(
                                        Icons.arrow_forward_ios_sharp,
                                        color: Colors.grey,
                                        size: 15,
                                      ),
                                    ),
                                    onTap: () {
                                      homeProvider.setIndexAddress(index);
                                    },
                                  ),
                                );
                              },
                              separatorBuilder: (BuildContext _, int __) {
                                return const Divider(
                                  thickness: 1,
                                  height: 5,
                                  color: AppColors.divider,
                                );
                              },
                              itemCount: homeProvider.myLocations.length,
                            );
                          }),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomButton(
                            height: 43,
                            color: AppColors.mainApp,
                            onPressed: () => context
                                .read<HomeProvider>()
                                .goToConfirmAddress(context),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  Assets.carBlueIC,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 10.0),
                                CustomText(
                                  Utils.localization?.askForGas,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          CustomButton(
                              height: 43,
                              onPressed: () async {
                                homeProvider.upsertLocation =
                                    await NavigatorUtils.goToManageAddress();
                              },
                              color: AppColors.secondaryButton,
                              //background color of button

                              //border width and color

                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    Assets.locationOutlinedIC,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 10.0),
                                  CustomText(
                                    Utils.localization?.selectYourLocation,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(color: Colors.white),
                                  ),
                                ],
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Consumer<HomeProvider>(
                        builder: (_, homeProvider, __) => GoogleMap(
                          // given camera position
                          initialCameraPosition: homeProvider.kGoogle,
                          // set markers on google map
                          markers: Set<Marker>.of(homeProvider.markers),
                          // on below line we have given map type
                          mapType: MapType.normal,
                          compassEnabled: false,

                          // disable zoom control
                          zoomControlsEnabled: false,
                          // below line displays google map in our app
                          onMapCreated: (GoogleMapController controller) {
                            if (!homeProvider.controller.isCompleted) {
                              homeProvider.controller.complete(controller);
                              homeProvider.controllerGoogleMap = controller;
                            }
                          },
                        ),
                      ),
                      Positioned(
                        top: 30,
                        right: 30,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          child: CustomText(
                            Utils.localization?.aroundYou,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
