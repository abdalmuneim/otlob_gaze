import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:otlob_gas/common/constants/assets.dart';
import 'package:otlob_gas/common/services/location_services.dart';
import 'package:otlob_gas/common/services/navigation_service.dart';
import 'package:otlob_gas/common/utils.dart';

class SelectLocationOnMapProvider extends ChangeNotifier {
  late LatLng currentPositionLatLen;
  final Completer<GoogleMapController> controller = Completer();
  final LocationServices _locationServices;

  late List<Marker> markers = <Marker>[];
  late CameraPosition kGoogle = CameraPosition(
    target: currentPositionLatLen,
    zoom: 15,
  );
  SelectLocationOnMapProvider(this._locationServices);

  init(context) async {
    final Position? position =
        await _locationServices.determinePosition(context);

    currentPositionLatLen = LatLng(position!.latitude, position.longitude);

    final Uint8List currentIcon =
        await Utils.getBytesFromAsset(Assets.pinIc, width: 45, height: 59);
    markers.clear();
    // add current icon to markers
    markers.add(
      Marker(
        // given marker id
        markerId: const MarkerId('${0}'),
        // given marker icon
        icon: BitmapDescriptor.fromBytes(currentIcon),
        // given position
        position: LatLng(position.latitude, position.longitude),
      ),
    );
  }

  changeMarker(LatLng? latLong) async {
    currentPositionLatLen = latLong!;
    markers[0] = markers[0].copyWith(
      positionParam: currentPositionLatLen,
    );
    notifyListeners();
  }

  void confirmLocation() {
    Navigator.pop(NavigationService.context, currentPositionLatLen);
  }
}
