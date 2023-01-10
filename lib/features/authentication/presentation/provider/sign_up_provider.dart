import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:otlob_gas/common/constants/navigator_utils.dart';
import 'package:otlob_gas/common/services/location_services.dart';
import 'package:otlob_gas/common/services/navigation_service.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/authentication/domain/entities/user.dart';
import 'package:otlob_gas/features/authentication/domain/usecases/edit_account_use_case.dart';
import 'package:otlob_gas/features/authentication/domain/usecases/sign_up_user_use_case.dart';

class SignUpProvider extends ChangeNotifier {
  final SignUpUserUseCase _signUpUserUseCase;
  final EditAccountUseCase _editAccountUseCase;
  User? currentUser;
  final LocationServices _locationServices;
  BuildContext get context => NavigationService.context;
  SignUpProvider(this._signUpUserUseCase, this._locationServices,
      this._editAccountUseCase);
  File? selectedImage;
  Future<void> pickPicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
      notifyListeners();
    }
  }

  void initEditAccount() {
    emailAddressController.text = currentUser?.email ?? '';
    nameController.text = currentUser?.name ?? '';
    addressController.text = currentUser?.address ?? '';
    mobileAddressController.text = currentUser?.mobile ?? '';
    lat = double.tryParse(currentUser?.location?.lat ?? '');
    long = double.tryParse(currentUser?.location?.long ?? '');
  }

  late TextEditingController emailAddressController;
  late TextEditingController passController;
  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController mobileAddressController;
  late TextEditingController confirmPasswordController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> signUp() async {
    validateImage();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate() || !isValidCords || !isValidImage) {
      return;
    }

    Utils.showLoading();
    final result = await _signUpUserUseCase(
      lat: lat!,
      long: long!,
      name: nameController.text,
      email: emailAddressController.text,
      mobile: mobileAddressController.text,
      address: addressController.text,
      image: selectedImage!.path,
      password: passController.text,
      confirmPassword: confirmPasswordController.text,
    );
    Utils.hideLoading();
    result.fold((l) => Utils.handleFailures(l), (message) {
      Utils.showToast(message);
    });
  }

  Future<void> editAccount() async {
    FocusScope.of(context).unfocus();
    validateImage();
    if (!formKey.currentState!.validate() || !isValidCords || !isValidImage) {
      return;
    }

    Utils.showLoading();
    hideLoading() => Utils.hideLoading();
    final result = await _editAccountUseCase(
      lat: lat!,
      long: long!,
      name: nameController.text,
      // email: emailAddressController.text,
      mobile: mobileAddressController.text,
      address: addressController.text,
      password: passController.text,
      image: selectedImage?.path,
      confirmPassword: confirmPasswordController.text,
    );
    hideLoading();
    result.fold((l) => Utils.handleFailures(l), (message) {
      Utils.showToast(message);
    });
  }

  double? lat;
  double? long;
  resetCords() {
    lat = null;
    long = null;
  }

  bool get isValidCords =>
      lat != null && long != null && addressController.text.isNotEmpty;
  bool isValidImage = true;
  validateImage() {
    isValidImage = selectedImage != null || isEditMode;
    notifyListeners();
  }

  Future<void> getAddressByGeoLocation(
    double lat,
    double long,
  ) async {
    this.lat = lat;
    this.long = long;
    addressController.text =
        await _locationServices.getAddressByGeoLocation(lat, long);
    notifyListeners();
  }

  Future<void> determinePosition() async {
    try {
      final latLng = await NavigatorUtils.goToSelectLocationOnMap();

      if (latLng == null) {
        return;
      }
      Utils.showLoading();

      await getAddressByGeoLocation(
        latLng.latitude,
        latLng.longitude,
      );
    } on LocationServiceDisabledException {
      _locationServices.showLocationError();
    } finally {
      Utils.hideLoading();
    }
  }

  bool isEditMode = false;
  initPage(bool isEditMode) {
    this.isEditMode = isEditMode;
    isValidImage = true;
    resetCords();
    selectedImage = null;

    emailAddressController = TextEditingController();
    passController = TextEditingController();
    nameController = TextEditingController();
    addressController = TextEditingController();
    mobileAddressController = TextEditingController();
    confirmPasswordController = TextEditingController();
    if (isEditMode) {
      initEditAccount();
    }
  }

  disposePage() {
    emailAddressController.dispose();
    passController.dispose();
    nameController.dispose();
    addressController.dispose();
    mobileAddressController.dispose();
    confirmPasswordController.dispose();
  }
}
