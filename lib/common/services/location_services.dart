import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart'
    show Position, LocationPermission, Geolocator;
import 'package:otlob_gas/common/utils.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationServices {
  showLocationError() {
    Utils.showErrorToast(Utils.localization!.enable_location, duration: 6);
  }

  Future<Position?> determinePosition(BuildContext context) async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      showLocationError() => this.showLocationError();
      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        if (await Permission.location.isPermanentlyDenied) {
          showLocationError();
        } else {
          final result = await Permission.location.request();

          serviceEnabled = result == PermissionStatus.granted;
        }
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.

          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        permission = await Geolocator.requestPermission();

        return null;
      }
      if (!serviceEnabled) {
        return null;
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      return await Geolocator.getCurrentPosition();
    } catch (error) {
      rethrow;
    }
  }

  /// get current lat long address
  Future<String> getAddressByGeoLocation(
    double lat,
    double long,
  ) async {
    List<Placemark> placeMarks = await placemarkFromCoordinates(
      lat,
      long,
    );

    return "${placeMarks[0].street ?? ''} ${placeMarks[0].subLocality ?? ''} ${placeMarks[0].locality ?? ''}";
  }

  double getDistance(
      {required double targetLat,
      required double targetLong,
      required double currentLat,
      required double currentLong}) {
    const p = 0.017453292519943295;
    final a = 0.5 -
        cos((targetLat - currentLat) * p) / 2 +
        cos(currentLat * p) *
            cos(targetLat * p) *
            (1 - cos((targetLong - currentLong) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }
}
