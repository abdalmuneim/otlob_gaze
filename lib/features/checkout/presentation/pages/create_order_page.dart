import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:otlob_gas/common/constants/assets.dart';
import 'package:otlob_gas/common/constants/font_manager.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/authentication/domain/entities/user_location.dart';
import 'package:otlob_gas/features/checkout/presentation/provider/create_order_provider.dart';
import 'package:otlob_gas/features/checkout/presentation/widgets/confirm_order_delivered_dialog_widget.dart';
import 'package:otlob_gas/features/checkout/presentation/widgets/create_order_options_slide_panel.dart';
import 'package:otlob_gas/features/checkout/presentation/widgets/current_order_slide_panel.dart';
import 'package:otlob_gas/widget/custom_app_bar.dart';
import 'package:otlob_gas/widget/custom_cached_image.dart';
import 'package:otlob_gas/widget/custom_text.dart';
import 'package:otlob_gas/widget/loading_widget.dart';
import 'package:otlob_gas/widget/show_widget_dialog.dart';
import 'package:provider/provider.dart';

class CreateOrderPage extends StatefulWidget {
  const CreateOrderPage({
    Key? key,
    required this.driverNotes,
    required this.quantity,
    required this.location,
  }) : super(key: key);
  final String? driverNotes;
  final int? quantity;
  final UserLocation? location;

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  late final CreateOrderProvider createOrderProvider =
      context.read<CreateOrderProvider>();

  @override
  void initState() {
    createOrderProvider.controller = Completer<GoogleMapController>();
    if (widget.location != null && widget.driverNotes != null) {
      createOrderProvider.location = widget.location;
      createOrderProvider.driverNotes = widget.driverNotes;
    }
    super.initState();
  }

  @override
  void dispose() {
    createOrderProvider.disposePage();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Selector<CreateOrderProvider, bool>(
        selector: (_, provider) => provider.isLoading,
        builder: (_, isLoading, __) {
          return Scaffold(
            appBar: CustomAppBar(
              title: isLoading
                  ? CustomText(
                      Utils.localization?.ask_gas_unit,
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(fontSize: 25),
                    )
                  : Selector<CreateOrderProvider, int>(
                      selector: (_, provider) => provider.order!.status ?? -1,
                      builder: (_, status, __) {
                        String? pageName = Utils.localization?.ask_gas_unit;
                        if (status == 1) {
                          pageName = Utils.localization?.current_order;
                        }
                        if (status == 2) {
                          pageName = Utils.localization?.order_details;
                        }
                        return CustomText(
                          pageName,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(fontSize: 25),
                        );
                      }),
              leading: const SizedBox(),
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    if (!isLoading)
                      Consumer<CreateOrderProvider>(
                          builder: (_, createOrderProvider, __) {
                        if (createOrderProvider.order!.status == -1) {
                          return Column(
                            children: [
                              Material(
                                elevation: 5,
                                child: Container(
                                  width: size.width,
                                  color: Colors.white,
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            /// user image
                                            Container(
                                              height: 40,
                                              width: 40,
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle),
                                              child: CustomCachedNetworkImage(
                                                url: createOrderProvider.order!
                                                    .driverData?.imageForWeb,
                                                boxFit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(width: 5),

                                            /// user name
                                            Text(
                                              createOrderProvider.order!
                                                      .driverData?.name ??
                                                  "",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium!
                                                  .copyWith(
                                                    fontWeight: FontWeightManger
                                                        .regular,
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                  ),
                                            ),
                                          ],
                                        ),

                                        /// storehouse location
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              Assets.locationOutlinedIC,
                                              color: Colors.red,
                                            ),
                                            const SizedBox(width: 5),
                                            CustomText(
                                              "${createOrderProvider.order!.distance ?? ""} ${Utils.localization?.behind_you ?? ''}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium!
                                                  .copyWith(
                                                      color: Colors.black),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Divider(
                                  thickness: 2,
                                  height: 2,
                                  color: Colors.grey[300]),

                              /// rating - arrive time - other data
                              Material(
                                elevation: 5,
                                child: Container(
                                  width: size.width,
                                  color: Colors.white,
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        /// rating
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              Assets.starFilled,
                                              height: 20,
                                            ),
                                            const SizedBox(width: 5),
                                            CustomText(
                                              '${createOrderProvider.order!.driverData?.rating ?? 0}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium!
                                                  .copyWith(fontSize: 18),
                                            )
                                          ],
                                        ),

                                        /// arrive time
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                                Assets.clockGreyIC),
                                            const SizedBox(width: 5),
                                            CustomText(
                                              Utils.localization?.arrive_minute(
                                                  int.parse(createOrderProvider
                                                          .order!.time ??
                                                      "0")),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium!
                                                  .copyWith(fontSize: 18),
                                            )
                                          ],
                                        ),

                                        /// other data
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              Assets.idCartIC,
                                            ),
                                            const SizedBox(width: 5),
                                            CustomText(
                                              Utils.localization?.other_data,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium!
                                                  .copyWith(fontSize: 18),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }

                        return const SizedBox();
                      }),
                    Expanded(
                      child: Selector<CreateOrderProvider, Set<Marker>>(
                          selector: (_, provider) =>
                              Set<Marker>.of(provider.markers),
                          builder: (_, markers, __) {
                            return GoogleMap(
                              initialCameraPosition: CameraPosition(
                                  zoom: 15,
                                  target:
                                      createOrderProvider.userPositionLatLong),
                              // set markers on google map
                              markers: markers,
                              // on below line we have given map type
                              mapType: MapType.normal,
                              // line between current location and driver location
                              polylines: createOrderProvider.polyLines,
                              compassEnabled: false,
                              zoomControlsEnabled: false,
                              // below line displays google map in our app
                              onMapCreated: (GoogleMapController controller) {
                                if (!createOrderProvider
                                    .controller.isCompleted) {
                                  createOrderProvider.controller
                                      .complete(controller);
                                  createOrderProvider.controllerGoogleMap =
                                      controller;
                                  createOrderProvider.init(
                                      location: widget.location,
                                      driverNotes: widget.driverNotes,
                                      quantity: widget.quantity);
                                }
                              },
                            );
                          }),
                    ),
                  ],
                ),
                if (!isLoading)
                  Selector<CreateOrderProvider, int>(
                    selector: (_, provider) => provider.order!.status ?? 0,
                    builder: (_, status, __) {
                      /// Create Order Options Slide Panel content
                      if (status == -1) {
                        return const CreateOrderOptionsSlidePanel();
                      } else if (status == 0) {
                        return ShowWidgetDialog(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          child: LoadingWidget(
                            description:
                                Utils.localization?.waiting_driver_acceptance ??
                                    '',
                          ),
                        );
                      } else if (status == 1 || status == 2 || status == 6) {
                        return Stack(
                          children: [
                            const CurrentOrderSlidePanel(),
                            if (status == 6 &&
                                createOrderProvider.order!.userEndTrip !=
                                    createOrderProvider.order!.driverId)
                              ShowWidgetDialog(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                child: LoadingWidget(
                                  description: Utils.localization
                                          ?.waiting_driver_delivery_confirmation ??
                                      '',
                                ),
                              ),
                            if (status == 6 &&
                                createOrderProvider.order!.userEndTrip ==
                                    createOrderProvider.order!.driverId)
                              const ShowWidgetDialog(
                                child: ConfirmOrderDeliveredDialogWidget(),
                              ),
                          ],
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  )
                else
                  const LoadingWidget()
              ],
            ),
          );
        });
  }
}
