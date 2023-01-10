import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:otlob_gas/common/constants/navigator_utils.dart';
import 'package:otlob_gas/features/authentication/domain/entities/user_location.dart';

class ConfirmAddressProvider extends ChangeNotifier {
  NumberFormat formatter = NumberFormat("00");
  int _count = 0;
  String get count => formatter.format(_count).toString();
  int get countInt => _count;
  TextEditingController buildingNumberController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController floorNumberController = TextEditingController();
  TextEditingController driverNotesController = TextEditingController();

  void changeCount({required bool increase}) {
    if (increase) {
      _count++;
    } else {
      if (_count == 1) {
        return;
      }
      _count--;
    }
    notifyListeners();
  }

  UserLocation? location;
  void init(UserLocation location) {
    this.location = location;
    buildingNumberController = TextEditingController();
    floorNumberController = TextEditingController();
    titleController = TextEditingController();
    driverNotesController = TextEditingController();
    _count = 1;
    buildingNumberController.text = location.buildingNumber!;
    floorNumberController.text = location.floorNumber!;
    titleController.text = location.title!;
  }

  void disposePage() {
    buildingNumberController.dispose();
    floorNumberController.dispose();
    titleController.dispose();
    driverNotesController.dispose();
  }

  void goToCreateOrder() {
    NavigatorUtils.goToCreateOrderPage(
      driverNotes: driverNotesController.text,
      location: location!,
      quantity: countInt,
    );
  }
}
