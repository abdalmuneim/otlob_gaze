import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:otlob_gas/common/constants/app_colors.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/home/presentation/widgets/select_location_on_map/select_location_on_map_provider.dart';
import 'package:otlob_gas/widget/custom_text.dart';
import 'package:otlob_gas/widget/loading_widget.dart';
import 'package:provider/provider.dart';

class SelectLocationOnMap extends StatefulWidget {
  const SelectLocationOnMap({Key? key}) : super(key: key);

  @override
  State<SelectLocationOnMap> createState() => _SelectLocationOnMapState();
}

class _SelectLocationOnMapState extends State<SelectLocationOnMap> {
  bool isLoading = true;
  late final selectLocationOnMapProvider =
      context.read<SelectLocationOnMapProvider>();

  init() async {
    await selectLocationOnMapProvider.init(context);
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
        body: isLoading
            ? const LoadingWidget()
            : Consumer<SelectLocationOnMapProvider>(
                builder: (_, selectLocationOnMapProvider, __) {
                return Stack(
                  children: [
                    GoogleMap(
                      // given camera position
                      initialCameraPosition:
                          selectLocationOnMapProvider.kGoogle,
                      onTap: selectLocationOnMapProvider.changeMarker,
                      // set markers on google map
                      markers:
                          Set<Marker>.of(selectLocationOnMapProvider.markers),
                      // on below line we have given map type
                      mapType: MapType.normal,

                      zoomControlsEnabled: false,
                      // below line displays google map in our app
                      onMapCreated: (GoogleMapController controller) {
                        if (!selectLocationOnMapProvider
                            .controller.isCompleted) {
                          selectLocationOnMapProvider.controller
                              .complete(controller);
                        }
                      },
                    ),
                    Positioned(
                      bottom: 30,
                      right: 30,
                      child: InkWell(
                        onTap: selectLocationOnMapProvider.confirmLocation,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.mainApp),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          child: CustomText(
                            Utils.localization?.selectYourLocation,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }));
  }
}
