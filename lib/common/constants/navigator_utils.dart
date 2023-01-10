import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:otlob_gas/common/constants/stored_keys.dart';
import 'package:otlob_gas/common/routes/route_strings.dart';
import 'package:otlob_gas/common/services/navigation_service.dart';
import 'package:otlob_gas/features/authentication/data/models/user_location_model.dart';
import 'package:otlob_gas/features/authentication/domain/entities/user_location.dart';
import 'package:otlob_gas/features/home/presentation/pages/manage_address_page.dart';
import 'package:otlob_gas/features/home/presentation/widgets/select_location_on_map/select_location_on_map.dart';

class NavigatorUtils {
  static BuildContext get _context => NavigationService.context;

  // go to add or edit address page
  static Future<UserLocation?> goToManageAddress(
      {UserLocation? myLocation}) async {
    return await Navigator.of(_context).push(
      MaterialPageRoute(
        builder: (_) {
          return ManageAddressPage(myLocation: myLocation);
        },
      ),
    );
  }

// go to confirm address before creating order
  static Future<void> goToConfirmAddress(
      {required UserLocation myLocation}) async {
    _context.pushNamed(RouteStrings.confirmAddress, queryParams: {
      StoredKeys.myLocation: (myLocation as UserLocationModel).toJson(),
    });
  }

// go to create order page
  static Future<void> goToCreateOrderPage({
    UserLocation? location,
    int? quantity,
    String? driverNotes,
  }) async {
    if (quantity == null && location == null && driverNotes == null) {
      _context.pushNamed(RouteStrings.createOrderPage);
    } else {
      _context.replaceNamed(RouteStrings.createOrderPage, queryParams: {
        StoredKeys.quantity: quantity.toString(),
        StoredKeys.driverNotes: driverNotes,
        StoredKeys.myLocation: (location as UserLocationModel).toJson(),
      });
    }
  }

// go to select location map
  static Future<LatLng?> goToSelectLocationOnMap() async {
    return await (Navigator.of(_context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const SelectLocationOnMap();
        },
      ),
    )) as LatLng?;
  }

// go to chat with driver page
  static Future<void> goToChatWithDriver(int orderId) async {
    return _context.pushNamed(RouteStrings.communicationWithTheDriver,
        queryParams: {StoredKeys.orderId: '$orderId'});
  }

// go to rate service page
  static Future<void> goToRateServicePage(int orderId) async {
    return _context.replaceNamed(RouteStrings.rateService,
        queryParams: {StoredKeys.orderId: '$orderId'});
  }

  ///   push otp page
  static Future<void> goToOTPPage(
      {required String phoneNumber, bool isVerifyAction = false}) async {
    return _context.pushNamed(
      RouteStrings.otpPage,
      queryParams: {
        StoredKeys.phoneNumber: phoneNumber,
        StoredKeys.isVerifyAction: isVerifyAction.toString()
      },
    );
  }

  ///   push Change Password  page
  static Future<void> goToChangePasswordPage(
      {required String phoneNumber}) async {
    return _context.replaceNamed(
      RouteStrings.changePasswordPage,
      queryParams: {
        StoredKeys.phoneNumber: phoneNumber,
      },
    );
  }
}
