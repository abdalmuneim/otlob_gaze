import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:otlob_gas/common/services/location_services.dart';
import 'package:otlob_gas/common/services/navigation_service.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/authentication/domain/entities/user_location.dart';
import 'package:otlob_gas/features/home/domain/usecases/add_my_location_use_case.dart';
import 'package:otlob_gas/features/home/domain/usecases/edit_my_location_use_case.dart';
import 'package:otlob_gas/features/home/presentation/widgets/select_location_on_map/select_location_on_map.dart';

class ManageAddressProvider extends ChangeNotifier {
  final AddMyLocationUseCase _addMyLocationUseCase;
  final EditMyLocationUseCase _editMyLocationUseCase;
  final LocationServices _locationServices;
  ManageAddressProvider(
    this._addMyLocationUseCase,
    this._editMyLocationUseCase,
    this._locationServices,
  );

  LatLng? latLng;
  bool isDefault = false;
  set setIsDefault(isDefault) {
    this.isDefault = isDefault;
    notifyListeners();
  }

  set setLatLng(latLng) {
    this.latLng = latLng;
  }

  TextEditingController buildingNumberController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController floorNumberController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  init(UserLocation? location) {
    buildingNumberController = TextEditingController();
    titleController = TextEditingController();
    floorNumberController = TextEditingController();
    latLng = null;
    isDefault = false;
    if (location != null) {
      buildingNumberController.text = location.buildingNumber!;
      titleController.text = location.title!;
      floorNumberController.text = location.floorNumber!;
      isDefault = location.defaultLocation!;
      latLng =
          LatLng(double.parse(location.lat!), double.parse(location.long!));
    }
  }

  disposePage() {
    buildingNumberController.dispose();
    titleController.dispose();
    floorNumberController.dispose();
  }

  Future<void> addMyLocation(BuildContext context) async {
    if (latLng == null) {
      Utils.showErrorToast(Utils.localization!.validate_location);
    }
    FocusScope.of(context).unfocus();

    if (formKey.currentState!.validate() && latLng != null) {
      Utils.showLoading();
      final result = await _addMyLocationUseCase(
        buildingNumber: buildingNumberController.text,
        floorNumber: floorNumberController.text,
        isDefault: isDefault,
        lat: latLng!.latitude,
        long: latLng!.longitude,
        title: titleController.text,
      );
      Utils.hideLoading();
      result.fold((failure) => Utils.handleFailures(failure), (location) {
        Navigator.pop(context, location);
      });
    }
  }

  Future<void> editMyLocation(BuildContext context,
      {required int locationId}) async {
    if (latLng == null) {
      Utils.showErrorToast(Utils.localization!.validate_location);
    }
    FocusScope.of(context).unfocus();
    if (formKey.currentState!.validate() && latLng != null) {
      Utils.showLoading();
      final result = await _editMyLocationUseCase(
        locationId: locationId,
        buildingNumber: buildingNumberController.text,
        floorNumber: floorNumberController.text,
        isDefault: isDefault,
        lat: latLng!.latitude,
        long: latLng!.longitude,
        title: titleController.text,
      );
      Utils.hideLoading();
      result.fold((failure) => Utils.handleFailures(failure), (location) {
        Navigator.pop(context, location);
      });
    }
  }

  void selectLocation() async {
    setLatLng = await (Navigator.of(NavigationService.context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const SelectLocationOnMap();
        },
      ),
    )) as LatLng;
    if (latLng != null) {
      titleController.text = await _locationServices.getAddressByGeoLocation(
          latLng!.latitude, latLng!.longitude);
    }
  }
}
