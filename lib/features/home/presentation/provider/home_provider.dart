import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:otlob_gas/common/constants/assets.dart';
import 'package:otlob_gas/common/constants/navigator_utils.dart';
import 'package:otlob_gas/common/services/navigation_service.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/authentication/domain/entities/user_location.dart';
import 'package:otlob_gas/features/authentication/presentation/provider/auth_provider.dart';
import 'package:otlob_gas/features/checkout/presentation/provider/create_order_provider.dart';
import 'package:otlob_gas/features/home/domain/entities/ads.dart';
import 'package:otlob_gas/features/home/domain/entities/nearest_driver.dart';
import 'package:otlob_gas/features/home/domain/usecases/get_ads_use_case.dart';
import 'package:otlob_gas/features/home/domain/usecases/get_my_locations_use_case.dart';
import 'package:otlob_gas/features/home/domain/usecases/get_nearest_drivers_use_case.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeProvider extends ChangeNotifier {
  final GetNearestDriversUseCase _getNearestDriversUseCase;
  final GetMyLocationsUseCase _getMyLocationsUseCase;
  final GetAdsUseCase _getAdsUseCase;

  HomeProvider(this._getNearestDriversUseCase, this._getAdsUseCase,
      this._getMyLocationsUseCase);
  UserLocation? location;
  int indexAddress = 0;
  BuildContext get context => NavigationService.context;

//select address to create order
  setIndexAddress(int indexAddress) async {
    if (indexAddress == this.indexAddress) {
      return;
    }
    Utils.showLoading();
    hideLoading() => Utils.hideLoading();
    this.indexAddress = indexAddress;
    currentPositionLatLen = LatLng(double.parse(myLocations[indexAddress].lat!),
        double.parse(myLocations[indexAddress].long!));
    controllerGoogleMap
        .animateCamera(CameraUpdate.newLatLng(currentPositionLatLen));
    await getNearestDrivers();
    await loadMapData();
    hideLoading();
    notifyListeners();
  }

//init home provider
  Future<void> initHome(BuildContext context) async {
// get nearest drivers is not included in future wait to get data before loadData start
    await getNearestDrivers();
    await Future.wait(<Future<void>>[
      getMyLocations(),
      getAds(),
      loadMapData(),
    ]);
    resetIndex();
  }

  final List<Ads> _ads = [];
  List<Ads> get ads => _ads;
  // get all ads
  Future<void> getAds() async {
    final result = await _getAdsUseCase();
    result.fold((failure) => Utils.handleFailures(failure), (ads) {
      _ads.clear();
      _ads.addAll(ads);
    });
  }

  Future<void> goToConfirmAddress(BuildContext context) async {
    if (context.read<CreateOrderProvider>().order?.status != null) {
      NavigatorUtils.goToCreateOrderPage();
    } else {
      NavigatorUtils.goToConfirmAddress(myLocation: myLocations[indexAddress]);
    }
  }

  final List<UserLocation> _myLocations = [];
  List<UserLocation> get myLocations => _myLocations;
  // get all my locations
  Future<void> getMyLocations() async {
    final result = await _getMyLocationsUseCase();
    result.fold((failure) => Utils.handleFailures(failure), (myLocations) {
      _myLocations.clear();
      _myLocations.addAll(myLocations);
      resetIndex();
    });
  }

// sort my locations by default address and reset indexAddress to 0
  resetIndex() {
    _myLocations.sort((a, b) => a.orderByDefaultLocation(b));

    indexAddress = 0;
  }

// update location if exist or add it if not exist
  set upsertLocation(UserLocation? myLocation) {
    if (myLocation == null) {
      return;
    }

    if (myLocation.defaultLocation!) {
      context.read<AuthProvider>().editUser(userLocation: myLocation);
      final newList =
          myLocations.map((e) => e = e..defaultLocation = false).toList();
      _myLocations.clear();
      _myLocations.addAll(newList);
    }

    final location =
        myLocations.firstWhereOrNull((element) => element.id == myLocation.id);
    if (location == null) {
      myLocations.add(myLocation);
    } else {
      final int index =
          myLocations.indexWhere((element) => element.id == myLocation.id);
      myLocations[index] = myLocation;
    }
    notifyListeners();
  }

  final List<NearestDriver> _nearestDrivers = [];
  List<NearestDriver> get nearestDrivers => _nearestDrivers;
  // get nearest drivers
  Future<void> getNearestDrivers() async {
    final result = await _getNearestDriversUseCase(
      lat: currentPositionLatLen.latitude,
      lng: currentPositionLatLen.longitude,
    );
    result.fold((failure) => Utils.handleFailures(failure), (nearestDrivers) {
      this.nearestDrivers.clear();
      _nearestDrivers.addAll(nearestDrivers);
    });
  }

  // created controller for displaying Google Maps
  final Completer<GoogleMapController> controller = Completer();
  late GoogleMapController controllerGoogleMap;

  // given camera position
  late CameraPosition kGoogle = CameraPosition(
    target: currentPositionLatLen,
    zoom: 14,
  );

  // created empty list of markers
  List<Marker> markers = <Marker>[];

  // current user location
  late LatLng currentPositionLatLen =
      LatLng(double.parse(location!.lat!), double.parse(location!.long!));

  // created method for displaying custom markers according to index
  loadMapData() async {
    markers.clear();

    //  current driver icon
    final Uint8List nearestDriverIcon =
        await Utils.getBytesFromAsset(Assets.carIc, width: 150, height: 75);
    // add nearest drivers markers
    for (var nearestDriver in nearestDrivers) {
      // markers added according to index
      markers.add(
        Marker(
          // given marker id
          markerId: MarkerId('${nearestDriver.id}'),
          // given marker icon
          icon: BitmapDescriptor.fromBytes(nearestDriverIcon),
          // given position
          position: LatLng(double.parse(nearestDriver.latitude!),
              double.parse(nearestDriver.longitude!)),
        ),
      );
    }
    // get current icon
    final Uint8List currentIcon =
        await Utils.getBytesFromAsset(Assets.pinIc, width: 45, height: 59);
    // add current icon to markers
    markers.add(
      Marker(
        // given marker id
        markerId: const MarkerId('${0}'),
        // given marker icon
        icon: BitmapDescriptor.fromBytes(currentIcon),
        // given position
        position: currentPositionLatLen,
      ),
    );
  }

//Launch Url
  Future<void> launchLink(String link) async {
    final Uri url = Uri.parse(link);
    launchUrl(url);
  }
}
